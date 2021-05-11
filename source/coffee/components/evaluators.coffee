module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'evaluators', {
      replace: true
      transclude: true
      templateUrl: 'components/evaluators.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        # subhead: '<'   # one way bind from parent scope

      # =========================================================================================================

      controller: ($rootScope, $scope, $mdMenu, $timeout, Data, Users, Districts, Regions, Forms) ->

        # to maintain scope across promises and functions
        ctrl = @

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          ctrl.dataLoading = true
          $scope.$on 'dataLoading', => ctrl.dataLoading = true

          # when the Data service says it's ready, let this component get to work (with promise error catching)
          # Data.ready.promise.then(@parseData).catch (error) -> console.error error
          $scope.$on 'dataReady', @parseData

        # ---------------------------------------------------------------------------------------------------

        @parseData = ->

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byEvaluator

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          @forms = angular.copy Data.forms.byEvaluator

          ctrl.tableData = []
          @data = []
          @durations = []

          hasData = false

          for id, evaluator of @forms
            # console.log '[ id ]', Users.lookup[ id ].email , Users.lookup[ id ].regionId
            evaluatorId = id

            for id, form of evaluator

              if Users.active.group.level is 3
                evalUser = Users.lookup[ form.payload.evaluator.id ]
                continue if evalUser.regionId isnt Regions.lookupByManagerId[ Users.active.id ].id

              if form.payload.status is 'completed'

                hasData = true

                if Users.active.group.level is 3
                  @data[ Users.lookup[form.payload.evaluatee.id].districtId ] ?= []
                  @data[ Users.lookup[form.payload.evaluatee.id].districtId ].push form

                if Users.active.group.level is 4
                  @data[ evaluatorId ] ?= []
                  @data[ evaluatorId ].push form

          console.log '[ @data ]', @data

          for id, person of @data

            completedDates = []

            evaluatorData = null

            for formId, form of person

              if Users.active.group.level is 3
                evaluator = Districts.lookup[id].manager

                if !evaluatorData?
                  evaluatorData =
                    evaluator: evaluator.email
                    evaluatorId: evaluator.id
                    totalCompleted: 0
                    totalCompletedLive: 0
                    totalCompletedVirtual: 0
                    totalCompletedOther: 0
                    lastCompletedDate: null
                    timeToSubmit: {}
                    districtId: id
                    district: Districts.lookup[id].name
                    region: Regions.lookupByManagerId[Users.active.id].name
                    regionId: Regions.lookupByManagerId[Users.active.id].id
                    evaluatorName: Users.getName evaluator

              if Users.active.group.level is 4
                console.log '%c ------- ', 'background-color: red; color: #000'
                console.log '%c id ', 'background-color: red; color: #000', id
                console.log '%c formId ', 'background-color: lime; color: #000', formId
                console.log '%c form ', 'background-color: lime; color: #000', form
                console.log '%c person ', 'background-color: lime; color: #000', person
                console.log '%c Districts.lookupByManagerId[id] ', 'background-color: lime; color: #000', Districts.lookupByManagerId[id]
                if Districts.lookupByManagerId[id]?
                  evaluator = Districts.lookupByManagerId[id].manager
                  evaluatorManagesDistrict = Districts.lookupByManagerId[id]

                if !evaluator or !evaluatorManagesDistrict
                  evaluateeDistrictId = form.payload.evaluatee.districtId
                  evaluateeDistrict = Districts.lookup[evaluateeDistrictId]
                  evaluatorManagesDistrict = evaluateeDistrict

                if !evaluatorData?
                  evaluatorData =
                    evaluator: Users.lookup[id].email
                    evaluatorId: Users.lookup[id].id
                    totalCompleted: 0
                    totalCompletedLive: 0
                    totalCompletedVirtual: 0
                    totalCompletedOther: 0
                    lastCompletedDate: null
                    timeToSubmit: {}
                    districtId: evaluatorManagesDistrict.id
                    district: evaluatorManagesDistrict.name
                    regionId: form.payload.evaluator.regionId
                    region: form.payload.evaluator.regionName
                    evaluatorName: Users.getName evaluator

              switch form.payload.activity.toLowerCase()
                when 'hcp face to face' then evaluatorData.totalCompletedLive++
                when 'hcp virtual' then evaluatorData.totalCompletedVirtual++
                when 'other' then evaluatorData.totalCompletedOther++

              evaluatorData.totalCompleted++

              completedDates.push form.payload.timestamp

              end = moment form.payload.fieldRideEnd
              end = end.add 1, 'days' #? subtract a day so time to submit is more accurate (should have timestamp on form)
              submitted = moment form.payload.firstSubmitted

              duration = moment.duration(submitted.diff(end))

              ms = duration.asMilliseconds()
              ms = 0 if ms < 0 || isNaN(ms) #? let ms be 0 is negative or NaN
              @durations.push ms

              # console.log '[ duration ]', duration
              # console.log '[ ms ]', ms

              # tempTime = moment.duration(ms)
              # console.log "Days:", tempTime.days()
              # console.log "Hours:", tempTime.hours()
              # console.log "Minutes:", tempTime.minutes()

            orderedDates = completedDates.sort (a, b) ->
              return Date.parse(a) > Date.parse(b)

            evaluatorData.lastCompletedDate = orderedDates[0]

            total = @durations.reduce (a, b) -> a + b
            average = total / @durations.length
            avg = moment.duration(average)

            times =
              days: avg.days()
              hours: avg.hours()
              minutes: avg.minutes()

            # evaluatorData.timeToSubmit.inDays = Math.round(avg.asDays() * 10) / 10
            evaluatorData.timeToSubmit.inDays = avg.asDays().toFixed 2
            evaluatorData.timeToSubmit.breakdown = times

            ctrl.tableData.push evaluatorData

          console.log '%c ctrl.tableData ', 'background-color: red; color: #000', ctrl.tableData

          ctrl.query =
            order : 'evaluator'
            page: 1
            limit: 5
            limitOptions: [5, 10, 25, {
              label: 'All',
              value: ->
                return ctrl.tableData.length
            }]

          $timeout(->
            ctrl.dataLoading = false
            ctrl.noData = !hasData
          , 0)

          # console.log '%c[ ctrl.tableData ]', 'color: orangered', ctrl.tableData

        # ----------------------------------------------------------------------------

        @viewDistrictData = (id) ->
          # console.log '[ viewDistrictData ]', id
          Users.setActive id

        # ----------------------------------------------------------------------------

        @reorder = ->
          return true
          # console.log '%c[ evaluatee table : reorder() ]', 'color: deeppink'

        @paginate = ->
          return true
          # console.log '%c[ evaluatee table : paginate() ]', 'color: yellow'

        @openMenu = ($mdMenu, ev) ->
          $mdMenu.open ev

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }