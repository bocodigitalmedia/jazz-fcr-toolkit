module.exports = (angular, defaults) ->
  angular.module defaults.app.name
    .factory 'Data', [
      '$q'
      'Firebase'
      'Users'
      '$rootScope'
      '$timeout'
      '$firebaseUtils'
      (
        $q
        Firebase
        Users
        $rootScope
        $timeout
        $firebaseUtils
      ) ->

        Data =

          isFiltering: false
          formId: null
          ready: $q.defer()

          forms:
            raw: {}                 # userData node from firebase, untouched
            all: {}                 # just the FORMS parsed from userData (but not sorted or filtered)
            byEvaluator: {}         # forms parsed by user with userId as key
            byEvaluatee: {}         # forms parsed by user with userId as key
            byRegion: {}            # forms parsed by region with regionId as key
            byDistrict: {}          # forms parsed by district with districtId as key
            byStatus: {}            # forms parsed by status (saved/submitted/rejected/completed)
            evaluateeInfo: {}       # collection of things like average score, num completed, etc - by userId
            byEvaluateeByStatus: {} # so we can easily get submitted/completed forms later
            byDistrictByStatus: {}
            byRegionByStatus: {}

          users:
            raw: {}            # users node from firebase, untouched
            all: {}            # complex lookup of full profile, by userid, of the user's form submissions
            ids: []            # simple lookup of just user ids

          regions:
            raw: {}            # regions node from firebase, untouched
            all: {}            # complex lookup by regionid of all the VALID regions
            ids: []            # simple lookup of region ids
            nameLookup: {}     # by name, return id

          actionItems:
            all: {}

          # ================================================================================================

          getAll: ->

            # set up a promise
            deferred = $q.defer()

            # determine which form ID to use
            Data.formId = defaults.formId[defaults.environment]

            # get all user data
            formPromise = Firebase.getObject 'userData'

            # get all region data
            regionPromise = Firebase.getRootObject 'organizations/byId/'

            # DONT FORGET TO PUT $LOADED ON FIREBASE PROMISES OMG
            promises = [
              formPromise.$loaded()
              regionPromise.$loaded()
            ]

            # wait until all promises are loaded to resolve
            $q.all(promises).then((data) ->

              Data.forms.raw = {}

              # strip out firebase properties (and add submissionId to payload)
              for fId, form of data[0]
                if fId.indexOf('$') is -1 && fId != 'forEach'
                  Data.forms.raw[fId] = form

              Data.regions.raw = {}

              # strip out firebase properties
              for rId, reg of data[1]
                if rId.indexOf('$') is -1 && rId != 'forEach'
                  for orId, oreg of defaults.activeRegions
                    if rId == oreg.id
                      Data.regions.raw[rId] = reg

              # finish promise
              deferred.resolve()

            # catch errors in promise calls
            ).catch (error) -> console.error error

            # send back the promise
            return deferred.promise

          # ------------------------------------------------------------------------

          getAllActionItems: (userId)->
            all = Firebase.getObject 'userData', userId, 'FormActionItems', defaults.formId[defaults.environment]
            all.$loaded().then =>
              Data.actionItems.all = $firebaseUtils.toJSON all
              console.log '%c Data.actionItems.all ', 'background-color: red; color: #000', Data.actionItems.all

          # ================================================================================================

          reset: ->

            @forms.all = {}
            @forms.allByStatus = {}
            @forms.allAll = {}
            @forms.actionItems = {}
            @forms.actionItemsAll = {}
            @forms.actionItemsByStatus = {}
            @forms.byEvaluator = {}
            @forms.byEvaluatee = {}
            @forms.byRegion = {}
            @forms.byDistrict = {}
            @forms.byStatus = {}
            @forms.evaluateeInfo = {}
            @forms.byEvaluateeByStatus = {}
            @forms.byDistrictByStatus = {}
            @forms.byRegionByStatus = {}

          # ------------------------------------------------------------------------

          parse: ->

            # reset arrays and objects
            @reset()

            # parse forms.raw into forms.all
            @parseRaw()

            # parse through the regions
            @parseRegions()

            # parse through the forms into byChunks
            @parseForms()

            # perform some manipulation and calculations on various things (such as last completed date)
            @doEvaluateeCalculations()

            #! REMOVE THIS TESTING STUFF
            # console.groupCollapsed "RAW FORM LIST FOR TESTING"
            # console.log 'formId', formId
            # for formId, formValue of @forms.all
            #   console.log formValue.payload.evaluatee.email, formValue.payload.evaluator.email, formValue.payload.evaluator.regionName, formValue.payload.status, JSON.stringify(formValue.payload.answers)
            # console.groupEnd()

          # ================================================================================================

          parseRaw: () ->

            # loop through all the raw userData
            for userId, userData of @forms.raw

              hasFormProgress = userData.FormProgress? and userData.FormProgress[@formId]?
              hasActionItems = userData.FormActionItems? and userData.FormActionItems[@formId]?
              user = Users.lookup[ userId ]
              userEmail = user.email
              isBocoLoggedIn = userEmail.indexOf("@gmail.com") > -1 or userEmail.indexOf("@bocodigital.com") > -1

              # we only care about one kind of thing (FormProgress) and one specific version (FormId) of said thing
              if hasFormProgress

                # loop through each form
                for formId, formValue of userData.FormProgress[@formId]

                  isBocoForm = formValue.payload.evaluatee.email.indexOf("@gmail.com") > -1 or formValue.payload.evaluatee.email.indexOf("@bocodigital.com") > -1
                  continue if !isBocoLoggedIn and isBocoForm

                  # make sure we save the submissionId with the form
                  formValue.payload.submissionId = formId

                  # this is the RAW list of ALL forms regardless of status (whereas forms.raw is the USERDATA NODE)
                  @forms.allAll[formId] = formValue

                  # get the 3 possible regions for this submission
                  userRegion = Users.lookup[ formValue.payload.evaluatee.id ]?.regionId?
                  evaluatorRegionThen = formValue.payload.evaluator.regionId
                  evaluatorRegionNow = Users.lookup[ formValue.payload.evaluator.id ].regionId

                  # if the USER doesn't have a REGION that means they're archived, get rid of form
                  continue if !userRegion

                  # if the EVALUATOR didn't have a region at the time of submission, get rid of form
                  continue if !evaluatorRegionThen

                  # if evaluator doesn't have a region they're probably test data (or otherwise bad)
                  # continue if !Users.lookup[ formValue.payload.evaluator.id ].regionId?

                  # lookup the evaluatee id because evaluatee only has email and array position as id
                  evaluateeId = Users.lookupIdByEmail[formValue.payload.evaluatee.email]

                  # for date range matching
                  date = moment formValue.payload.timestamp

                  # is date in range?
                  validDate = (!$rootScope.dateStart && !$rootScope.dateEnd) or (date.isBetween $rootScope.dateStart, $rootScope.dateEnd)

                  # skip it if not
                  continue if not validDate

                  # only add it to the form array if it belongs to this user (based on level)
                  @parseRawLoop formId, formValue, evaluateeId

              # but actually now we want two things
              if hasActionItems

                # loop through each form
                for actionItemId, actionItemValue of userData.FormActionItems[@formId]

                  actionItemUserEmail = Users.lookup[ actionItemValue.userId ].email
                  isBocoForm = actionItemUserEmail.indexOf("@gmail.com") > -1 or actionItemUserEmail.indexOf("@bocodigital.com") > -1
                  continue if !isBocoLoggedIn and isBocoForm

                  # add to all action items
                  @forms.actionItemsAll[actionItemId] = actionItemValue

                  # only add it to the form array if it belongs to this user (based on level)
                  @parseRawLoopActionItems actionItemId, actionItemValue, actionItemValue.userId

          # ================================================================================================

          parseRawLoop: (formId, formValue, evaluateeId) ->

            # is this a valid form for this user based on their level and hierarchy
            addIt = false
            switch Users.active.group.level
              when 1
                addIt = true if Users.active.id is evaluateeId
              when 2
                addIt = true if evaluateeId in Users.descendants.users
              when 3
                addIt = true if evaluateeId in Users.descendants.users
              when 4
                addIt = true

            # don't add it if it's not valid for this user
            return if not addIt

            # we're gonna use this a few times
            status = formValue.payload.status

            # save it to two places, all (if it's above 'saved' level)...
            @forms.all[formId] = formValue if status in ['submitted', 'rejected', 'completed']

            # ...and allByStatus
            @forms.allByStatus[status] ?= {}
            @forms.allByStatus[status][formId] = formValue

          # ================================================================================================

          parseRawLoopActionItems: (actionItemId, actionItemValue, evaluateeId) ->

            localVerbose = true

            console.log '%c ------- ', 'background-color: red; color: #000' if localVerbose
            console.log '%c actionItemId ', 'background-color: red; color: #000', actionItemId if localVerbose
            console.log '%c actionItemValue ', 'background-color: red; color: #000', actionItemValue if localVerbose
            console.log '%c evaluateeId ', 'background-color: lime; color: #000', evaluateeId if localVerbose
            console.log '%c actionItemValue.submissionId ', 'background-color: lime; color: #000', actionItemValue.submissionId if localVerbose
            console.log '%c @forms.allAll[ actionItemValue.submissionId ] ', 'background-color: lime; color: #000', @forms.allAll[ actionItemValue.submissionId ] if localVerbose

            # ignore this orphaned action item, someone deleted its parent form
            return if !@forms.allAll[ actionItemValue.submissionId ]

            # don't include it if the form isn't submitted yet
            return if @forms.allAll[ actionItemValue.submissionId ].payload.status is 'saved'

            # is this a valid form for this user based on their level and hierarchy
            addIt = false
            switch Users.active.group.level
              when 1
                addIt = true if Users.active.id is evaluateeId
              when 2
                addIt = true if evaluateeId in Users.descendants.users
              when 3
                addIt = true if evaluateeId in Users.descendants.users
              when 4
                addIt = true

            # don't add it if it's not valid for this user
            return if not addIt

            # we're gonna use this a few times
            status = actionItemValue.status

            # save it to two places, all...
            @forms.actionItems[actionItemId] = actionItemValue

            # ...and actionItemsByStatus
            @forms.actionItemsByStatus[status] ?= {}
            @forms.actionItemsByStatus[status][actionItemId] = actionItemValue

          # ================================================================================================

          parseRegions: () ->

            # to lookup ids by name
            @regions.nameLookup = {}

            # loop through all the raw region data
            for regionId, regionData of @regions.raw

              # add the id to the simple lookup
              @regions.ids.push regionId

              # add to the 'by name' lookup
              @regions.nameLookup[regionData.name] = regionId

              # also push to the all regions array
              @regions.all[regionId] = regionData

          # ================================================================================================

          parseForms: () ->

            # loop through the entire forms.all set so we can turn it into usable pieces
            for formId, formData of @forms.all

              # add total and average to form BEFORE parsing
              @doFormCalculations formData

              # add things to the evaluatee and evaluator like district, region etc
              @addUserDetails formId, formData

              # group them up inside @forms
              @byEvaluator formId, formData
              @byEvaluatee formId, formData
              @byDistrict formId, formData
              @byRegion formId, formData
              @byStatus formId, formData

            # also create an array by employee/district/region by status (for "completed forms for a user" etc)
            @byEvaluateeByStatus()
            @byDistrictByStatus()
            @byRegionByStatus()
            @findLastCompletedDate()

          # ------------------------------------------------------------------------

          doFormCalculations: (formData) ->

            # console.log '-------'
            # console.log 'formData.payload.answers', formData.payload.answers

            #! LOOP AND STRIP FALSE includedQuestions
            validAnswers = []
            i = 0
            for answer in formData.payload.answers
              if defaults.includedQuestions[i]
                validAnswers.push answer
              i++

            # console.log 'validAnswers', validAnswers

            # filter out any N/A answers
            realData = validAnswers.filter (val) -> val isnt defaults.naValue

            # console.log 'realData', realData

            # break out if they answered all NA
            if realData.length == 0
              formData.payload.total = 0
              formData.payload.numAnswered = 0
              formData.payload.average = 0
              return

            # get the total score for each form
            # TODO: THIS SHOULD PARSE OUT NA
            total = realData.reduce (sum, val) -> sum + val

            # and the average (not rounded for more specific calculations later, views can round)
            average = total / realData.length

            # get the min and max answer for some reason
            formData.payload.ratingMin = Math.min.apply null, realData
            formData.payload.ratingMax = Math.max.apply null, realData

            # save back to form for easier use later
            formData.payload.total = total
            formData.payload.numAnswered = realData.length
            formData.payload.average = Math.round(average * 100) / 100

          # ------------------------------------------------------------------------

          addUserDetails: (formId, formData) ->

            # -------------------------
            # EVALUATEE
            # -------------------------

            # look up the EVALUATEE details by email then id
            evaluateeEmail = formData.payload.evaluatee.email
            evaluateeId = Users.lookupIdByEmail[ evaluateeEmail ]
            evaluateeDetails = Users.lookup[ evaluateeId ]

            # add districtName to EVALUATEE so we don't have to look it up later
            evaluateeDetails.districtName = defaults.activeDistricts[ evaluateeDetails.districtId ].name if evaluateeDetails.districtId? and defaults.activeDistricts[ evaluateeDetails.districtId ]?
            evaluateeDetails.regionName = defaults.activeRegions[ evaluateeDetails.regionId ].name if evaluateeDetails.regionId? and defaults.activeRegions[ evaluateeDetails.regionId ]?

            # push full EVALUATEE details back to form
            formData.payload.evaluatee = angular.copy evaluateeDetails

            # -------------------------
            # EVALUATOR
            # -------------------------

            # look up the EVALUATOR details by id
            evaluatorDetails = angular.copy Users.lookup[ formData.payload.evaluator.id ]

            # keep a few values from the original form EVALUATOR
            tempEvaluatorDetails = angular.copy formData.payload.evaluator
            evaluatorDetails.mgrEmail = tempEvaluatorDetails.mgrEmail
            evaluatorDetails.name = tempEvaluatorDetails.name

            # console.log 'formData.payload', formData.payload
            # console.log 'evaluatorDetails', evaluatorDetails
            # console.log 'defaults.activeRegions[ evaluatorDetails.regionId ]', defaults.activeRegions[ evaluatorDetails.regionId ]

            # if we're in a bad data situation just skip and keep going
            region = defaults.activeRegions[ evaluatorDetails.regionId ]

            # add regionName to EVALUATEE so we don't have to look it up later
            evaluatorDetails.regionName = region.name if region?

            # save the original regionId of the form
            originalRegionId = formData.payload.evaluator.regionId

            # push full EVALUATOR details back to form
            formData.payload.evaluator = angular.copy evaluatorDetails

            # restore the original regionId of the form
            formData.payload.evaluator.regionIdOriginal = originalRegionId

          # ------------------------------------------------------------------------

          byEvaluator: (formId, formData) ->

            # who is the evaluator
            evaluatorId = formData.payload.evaluator.id

            # if we don't have this evaluator in our collection yet, add them
            @forms.byEvaluator[evaluatorId] = {} unless @forms.byEvaluator[evaluatorId]

            # push the form to the evaluator's array
            @forms.byEvaluator[evaluatorId][formId] = formData

          # ------------------------------------------------------------------------

          byEvaluatee: (formId, formData) ->

            # who is the evaluator
            evaluateeId = formData.payload.evaluatee.email

            # if we don't have this evaluatee in our collection yet, add them
            @forms.byEvaluatee[evaluateeId] = {} unless @forms.byEvaluatee[evaluateeId]

            # push the form to the evaluatee's array
            @forms.byEvaluatee[evaluateeId][formId] = formData

          # ------------------------------------------------------------------------

          byDistrict: (formId, formData) ->

            # first get the EVALUATEE
            evaluateeId = Users.lookupIdByEmail[ formData.payload.evaluatee.email ]

            # get the employee
            evaluatee = Users.lookup[ evaluateeId ]

            # if we can't find the user, stop trying
            return if !evaluatee

            # get the district id
            districtId = Users.lookup[ evaluateeId ].districtId

            # if this form doesn't belong to a district there's a problem
            return if !districtId

            # if we don't have this district in our collection yet, add it
            @forms.byDistrict[districtId] = {} unless @forms.byDistrict[districtId]

            # push the form to the district's array
            @forms.byDistrict[districtId][formId] = formData

          # ------------------------------------------------------------------------

          byRegion: (formId, formData) ->

            evaluatorRegionThen = formData.payload.evaluator.regionIdOriginal
            evaluatorRegionNow = formData.payload.evaluator.regionId

            # get the region id
            regionId = evaluatorRegionNow || evaluatorRegionThen

            # if we don't have this region in our collection yet, add it
            @forms.byRegion[regionId] = {} unless @forms.byRegion[regionId]

            # push the form to the region's array
            @forms.byRegion[regionId][formId] = formData

          # ------------------------------------------------------------------------

          byStatus: (formId, formData) ->

            # what is the status
            status = formData.payload.status

            # if we don't have this evaluator in our collection yet, add them
            @forms.byStatus[status] = {} unless @forms.byStatus[status]

            # push the form to the evaluator's array
            @forms.byStatus[status][formId] = formData

          # ------------------------------------------------------------------------

          byEvaluateeByStatus: () ->

            # loop through each evaluatee
            for evaluateeId, evaluateeData of @forms.byEvaluatee

              # if we don't have this evaluatee in our collection yet, add them
              @forms.byEvaluateeByStatus[evaluateeId] = {} unless @forms.byEvaluateeByStatus[evaluateeId]

              for formId, formData of evaluateeData

                # what is the status
                status = formData.payload.status

                # if we don't have this evaluator in our collection yet, add them
                @forms.byEvaluateeByStatus[evaluateeId][status] = [] unless @forms.byEvaluateeByStatus[evaluateeId][status]

                # push the form to the evaluator's array
                @forms.byEvaluateeByStatus[evaluateeId][status].push formData

          # ------------------------------------------------------------------------

          byDistrictByStatus: () ->

            # loop through each district
            for districtId, districtData of @forms.byDistrict

              # if we don't have this district in our collection yet, add them
              @forms.byDistrictByStatus[districtId] = {} unless @forms.byDistrictByStatus[districtId]

              for formId, formData of districtData

                # what is the status
                status = formData.payload.status

                # if we don't have this evaluator in our collection yet, add them
                @forms.byDistrictByStatus[districtId][status] = [] unless @forms.byDistrictByStatus[districtId][status]

                # push the form to the evaluator's array
                @forms.byDistrictByStatus[districtId][status].push formData

          # ------------------------------------------------------------------------

          byRegionByStatus: () ->

            # loop through each region
            for regionId, regionData of @forms.byRegion

              # if we don't have this region in our collection yet, add them
              @forms.byRegionByStatus[regionId] = {} unless @forms.byRegionByStatus[regionId]

              for formId, formData of regionData

                # what is the status
                status = formData.payload.status

                # if we don't have this evaluator in our collection yet, add them
                @forms.byRegionByStatus[regionId][status] = [] unless @forms.byRegionByStatus[regionId][status]

                # push the form to the evaluator's array
                @forms.byRegionByStatus[regionId][status].push formData

          # ------------------------------------------------------------------------

          findLastCompletedDate: () ->

            # loop through each evaluatee
            for evaluateeEmail, evaluateeData of @forms.byEvaluatee

              # get user id for lookup later
              evaluateeId = Users.lookupIdByEmail[ evaluateeEmail ]

              # store all the values
              arr = []

              # create array of all timestamps
              arr.push formData.payload.timestamp for formId, formData of evaluateeData

              if arr.length <= 1
                Users.lookup[evaluateeId].lastCompletedFCR = '-'
              else
                arr.sort()
                Users.lookup[evaluateeId].lastCompletedFCR = arr[ arr.length - 2 ]

          # ------------------------------------------------------------------------

          doEvaluateeCalculations: () ->

            # loop each user who has forms
            for userId, userForms of @forms.byEvaluatee

              scores = []
              timestamps = []
              daysInField = 0
              statusCounts =
                submitted: 0
                rejected: 0
                completed: 0
                live: 0
                virtual: 0

              # loop through each form and gather up info
              for formId, form of userForms

                scores.push form.payload.average
                timestamps.push new Date(form.payload.timestamp) if form.payload.timestamp?
                statusCounts[form.payload.status]++
                statusCounts[form.payload.activity.toLowerCase()]++
                daysInField += form.payload.daysInField

              totalScore = scores.reduce ((a, b) -> a + b), 0
              avgScore = totalScore / scores.length
              minScore = Math.min.apply(null, scores)
              maxScore = Math.max.apply(null, scores)
              maxDate = new Date Math.max.apply(null, timestamps)

              @forms.evaluateeInfo[userId] =
                scores: scores
                timestamps: timestamps
                daysInField: daysInField
                statusCounts: statusCounts
                maxScore: maxScore
                minScore: minScore
                avgScore: avgScore
                maxDate: maxDate

          #~------------------------------------------------------------------------------------------
          #~ DATE RANGE PICKER
          #~------------------------------------------------------------------------------------------

          selectedRange:
            dateStart: null
            dateEnd: null
            showTemplate: false
            localizationMap: $rootScope.locale.dateTimeMap

          onSelect: (ev) ->
            $timeout =>
              # console.log @selectedRange
              # console.log ev
              $rootScope.dateStart = @selectedRange.dateStart
              $rootScope.dateEnd = @selectedRange.dateEnd
              $rootScope.userDefinedRange = true
              @isFiltering = true
              $rootScope.toolkitRefresh()

          clearDateRange: ->
            @selectedRange.dateStart = $rootScope.dateStart = null
            @selectedRange.dateEnd = $rootScope.dateEnd = null
            @selectedRange.selectedTemplateName = 'Filter by Date Range'
            $rootScope.userDefinedRange = false
            @isFiltering = false
            $rootScope.toolkitRefresh()

          #~ ================================================================================================
          #~ INIT
          #~ ================================================================================================

          init: ->

            # set up a promise
            deferred = $q.defer()

            # tell all the charts to turn off
            $rootScope.$broadcast 'dataReloading'

            # get all user data
            dataPromise = @getAll()

            # wait until all promises are loaded to resolve
            $q.all( [dataPromise] ).then(=>

              # parse the data into what we need for the charts
              @parse()

              $('#dashboard, #scroll').scrollTop(0) if not @isFiltering

              @isFiltering = false

              # finish promise
              deferred.resolve()

            # catch errors in promise calls
            ).catch (error) -> console.error error

            # send back the promise
            deferred.promise

          #~ ================================================================================================
    ]
