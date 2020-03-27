module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'glance', {
      replace: true
      transclude: true
      templateUrl: 'components/glance.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, $filter, Data, Forms, Users, Districts, Regions) ->

        #* to maintain scope across promises and functions
        ctrl = @

        @baseline = defaults.naValue - 1
        @avgProficiency = 0

        @brand = defaults.brand

        @config =
          chart:
            type: 'pie'
            width: 180
            height: 180
            backgroundColor: 'transparent'
            events:
              addSeries: (event) =>
                chart = event.target
                # console.log '%c[ chart ]', 'color: yellow', chart
                textX = chart.plotLeft + chart.plotWidth * 0.5
                textY = chart.plotTop + chart.plotHeight * 0.5
                span = '''
                  <span id="pieChartInfoText" style="position:absolute; text-align:center;">
                    <span style="font-size: 32px">''' + ctrl.avgProficiency + '''</span>
                  </span>'''
                $('#proficiency-percentage').html span
                span = $('#pieChartInfoText')
                span.css 'left', textX + span.width() * -0.5
                span.css 'top', textY + span.height() * -0.5
          credits:
            enabled: false
          exporting:
            enabled: false
          title:
            text: null
          subtitle:
            text: null
          tooltip:
            enabled: false
          colors: [
            '#ED4279'
            '#F8E8EE'
          ]
          plotOptions:
            pie:
              borderColor: 'transparent'
              innerSize: '65%'
              dataLabels: enabled: false
            series: states: hover: enabled: false
          series: []

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          ctrl.dataLoading = true
          $scope.$on 'dataLoading', => ctrl.dataLoading = true

          $scope.$on 'dataReady', =>
            switch Users.active.group.level
              when 1 then @parseUserData()
              when 2 then @parseManagerData()
              when 3 then @parseRegionalData()
              when 4 then @parseNationalData()
            $timeout(->
              ctrl.dataLoading = false
            , 0)

        # ---------------------------------------------------------------------------------------------------

        @parseUserData = =>

          # console.log '%c[ @parseUserData ]', 'color: yellow'

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byEvaluateeByStatus[ Users.active.email ]?.completed?

          @info = angular.copy Data.forms.evaluateeInfo[ Users.active.email ]
          @user = angular.copy Users.lookup[ Users.active.id ]

          if ctrl.noData
            @forms = []
          else
            @forms = angular.copy Data.forms.byEvaluateeByStatus[ Users.active.email ].completed
          # console.log '%c[ @info ]', 'color: lime', @info
          # console.log '%c[ @user ]', 'color: yellow', @user
          # console.log '%c[ defaults.activeDistricts ]', 'color: aqua', defaults.activeDistricts

          # @calculateSeriesData @forms

        # ---------------------------------------------------------------------------------------------------

        @parseManagerData = =>

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byDistrictByStatus[ Districts.lookupByManagerId[ Users.active.id ].id ]?.completed?

          # @info = angular.copy Data.forms.evaluateeInfo[ Users.active.email ]
          # @user = angular.copy Users.lookup[ Users.active.id ]

          if ctrl.noData
            @forms = []
          else
            # @forms = angular.copy Data.forms.byEvaluator[ Users.active.id ]
            districtId = Districts.lookupByManagerId[ Users.active.id ].id
            @forms = angular.copy Data.forms.byDistrict[ districtId ]
          # console.log '%c[ @info ]', 'color: lime', @info
          # console.log '%c[ @user ]', 'color: yellow', @user
          # console.log '%c[ defaults.activeDistricts ]', 'color: aqua', defaults.activeDistricts

          @info =
            timeToSubmit: {}
            completed: 0
            employees: Users.subordinates.length

          @tableData = []
          @byId = []
          @durations = []

          # @calculateSeriesData @forms

          for id, form of @forms
            # console.log '[ form ]', form

            #* tally completed form count
            @info.completed++ if form.payload.status is 'completed'

            if form.payload.status is 'completed'
              @byId[form.payload.evaluatee.id] ?= []
              @byId[form.payload.evaluatee.id].push form

              end = moment form.payload.fieldRideEnd
              end = end.add 1, 'days' #? subtract a day so time to submit is more accurate (should have timestamp on form)
              submitted = moment form.payload.firstSubmitted

              duration = moment.duration(submitted.diff(end))

              ms = duration.asMilliseconds()
              ms = 0 if ms < 0 #? let ms be 0 is negative
              @durations.push ms

              # console.log '[ duration ]', duration
              # console.log '[ ms ]', ms

              # tempTime = moment.duration(ms)
              # console.log "Days:", tempTime.days()
              # console.log "Hours:", tempTime.hours()
              # console.log "Minutes:", tempTime.minutes()

          if @durations.length
            total = @durations.reduce (a, b) -> a + b
            average = total / @durations.length
            avg = moment.duration(average)

            times =
              days: avg.days()
              hours: avg.hours()
              minutes: avg.minutes()

            # @info.timeToSubmit.inDays = Math.round(avg.asDays() * 10) / 10
            @info.timeToSubmit.inDays = avg.asDays().toFixed 2
            @info.timeToSubmit.breakdown = times

            # console.log '[ @durations ]', @durations
            # console.log '[ total ]', total
            # console.log '[ average ]', average

            # console.log '[ in Days as decimal ]', avg.asDays().toFixed(2)

            # console.log "Days:", avg.days()
            # console.log "Hours:", avg.hours()
            # console.log "Minutes:", avg.minutes()

          # console.log '[ @byId ]', @byId

          for id, forms of @byId
            # console.log '------------------------'
            # console.log 'id', id

            userData = {}

            completedDates = []
            averageRatings = []

            userData =
              employee: {}
              evaluator: {}
              lastCompletedDate: ''
              avgRating: @baseline
              minRating: @baseline
              maxRating: 0
              totalDays: 0
              totalDaysLive: 0
              totalDaysVirtual: 0
              totalCompleted: 0
              timestamp: null
              evaluateeName: ''
              evaluatorName: ''

            # for form in forms when form.payload.status is 'completed'
            for form in forms
              # console.log '[ form ]', form

              userData.employee.id = form.payload.evaluatee.id
              userData.employee.email = form.payload.evaluatee.email
              userData.evaluateeName = Users.getName form.payload.evaluatee
              # userData.employee.email = $filter('shorten')(form.payload.evaluatee.email)

              userData.evaluator.id = form.payload.evaluator.id
              userData.evaluator.email = form.payload.evaluator.email
              userData.evaluatorName = Users.getName form.payload.evaluator
              # userData.evaluator.email = $filter('shorten')(form.payload.evaluator.email)

              completedDates.push form.payload.timestamp

              averageRatings.push form.payload.average

              userData.minRating = form.payload.ratingMin if form.payload.ratingMin < userData.minRating
              userData.maxRating = form.payload.ratingMax if form.payload.ratingMax > userData.maxRating

              userData.totalDays += form.payload.daysInField

              switch form.payload.activity.toLowerCase()
                when 'live' then userData.totalDaysLive += form.payload.daysInField
                when 'virtual' then userData.totalDaysVirtual += form.payload.daysInField

              userData.totalCompleted++

              userData.timestamp = form.payload.timestamp

            # console.log 'completedDates', completedDates

            orderedDates = completedDates.sort (a, b) ->
              return Date.parse(b) - Date.parse(a)

            # console.log 'orderedDates', orderedDates
            # console.log 'orderedDates[0]', orderedDates[0]

            userData.lastCompletedDate = orderedDates[0]
            avg = (averageRatings.reduce (a, b) -> a + b) / averageRatings.length
            # userData.avgRating = Math.round(avg * 10) / 10
            userData.avgRating = avg.toFixed 2

            @tableData.push userData

          # console.log '%c[ @info ]', 'color: lime', @info
          # console.log '%c[ @tableData ]', 'color: deeppink', @tableData

          ctrl.query =
            order : 'evaluatee.email'
            page: 1
            limit: 5
            limitOptions: [5, 10, 25, {
              label: 'All',
              value: =>
                return @tableData.length
            }]

        # ---------------------------------------------------------------------------------------------------

        @parseRegionalData = =>

          # console.log '%c[ @parseRegionalData ]', 'color: yellow'

          region = Regions.lookupByManagerId[Users.active.id]

          districts = region.districts

          # for messaging (and stopping errors) if there's no forms to parse
          @noData = !Data.forms.byRegionByStatus[ region.id ]?.completed?

          if @noData
            @forms = []
          else
            @forms = angular.copy Data.forms.byRegion[ region.id ]

          @info =
            regionalManagerName: Users.getName region.manager
            regionalManager: region.manager.email
            completed: 0
            employees: 0
            timeToSubmit: {}

          @tableData = []
          @byDistrict = []
          @durations = []

          # @calculateSeriesData @forms

          for id, form of @forms
            # console.log '[ form ]', form

            #* tally completed form count
            @info.completed++ if form.payload.status is 'completed'

            if form.payload.status is 'completed'
              @byDistrict[ Users.lookup[form.payload.evaluatee.id].districtId ] ?= []
              @byDistrict[ Users.lookup[form.payload.evaluatee.id].districtId ].push form

              end = moment form.payload.fieldRideEnd
              end = end.add 1, 'days' #? subtract a day so time to submit is more accurate (should have timestamp on form)
              submitted = moment form.payload.firstSubmitted

              duration = moment.duration(submitted.diff(end))

              ms = duration.asMilliseconds()
              ms = 0 if ms < 0 #? let ms be 0 is negative
              @durations.push ms

              # console.log '[ duration ]', duration
              # console.log '[ ms ]', ms

              # tempTime = moment.duration(ms)
              # console.log "Days:", tempTime.days()
              # console.log "Hours:", tempTime.hours()
              # console.log "Minutes:", tempTime.minutes()

          if @durations.length
            total = @durations.reduce (a, b) -> a + b
            average = total / @durations.length
            avg = moment.duration(average)

            times =
              days: avg.days()
              hours: avg.hours()
              minutes: avg.minutes()

            # @info.timeToSubmit.inDays = Math.round(avg.asDays() * 10) / 10
            @info.timeToSubmit.inDays = avg.asDays().toFixed 2
            @info.timeToSubmit.breakdown = times

          # console.log '[ @byDistrict ]', @byDistrict

          totalReps = 0

          for id, forms of @byDistrict
            # console.log '[ district id ]', id

            averageRatings = []
            uniqueUser = []

            # console.log '[ region.manager.id ]', region.manager.id

            district = Districts.lookup[id]

            DistrictData =
              id: id
              name: district.name
              evaluator: district.manager.email
              evaluatorId: district.manager.id
              reps: 0
              totalDays: 0
              totalDaysLive: 0
              totalDaysVirtual: 0
              totalCompleted: 0
              avgRating: 0
              evaluatorName: Users.getName district.manager

            totalReps += Users.lookupByDistrict[ district.id ].length

            for form in forms

              uniqueUser.push form.payload.evaluatee.email if form.payload.evaluatee.email not in uniqueUser

              averageRatings.push form.payload.average
              avg = (averageRatings.reduce (a, b) -> a + b) / averageRatings.length
              # DistrictData.avgRating = Math.round(avg * 10) / 10
              DistrictData.avgRating = avg.toFixed 2

              DistrictData.totalDays += form.payload.daysInField

              switch form.payload.activity.toLowerCase()
                when 'live' then DistrictData.totalDaysLive += form.payload.daysInField
                when 'virtual' then DistrictData.totalDaysVirtual += form.payload.daysInField

              DistrictData.totalCompleted++

              DistrictData.reps = uniqueUser.length

            @tableData.push DistrictData

            # console.log '%c[ @info ]', 'color: lime', @info
            # console.log '%c[ @tableData ]', 'color: deeppink', @tableData

          ctrl.query =
            order : 'name'
            page: 1
            limit: 5
            limitOptions: [5, 10, 25, {
              label: 'All',
              value: =>
                return @tableData.length
            }]

          @info.employees = totalReps

        # ---------------------------------------------------------------------------------------------------

        @parseNationalData = =>

          # console.log '%c[ @parseNationalData ]', 'color: yellow'

          # for messaging (and stopping errors) if there's no forms to parse
          @noData = !Data.forms.all?

          if @noData
            @forms = []
          else
            @forms = angular.copy Data.forms.all

          # console.log '[ @forms ]', @forms

          @info =
            nationalDirector: defaults.activeTeam.manager.email
            completed: 0
            employees: Users.subordinates.length
            timeToSubmit: {}

          @byRegion = []
          @tableData = []
          @durations = []

          # @calculateSeriesData @forms

          hasData = false

          for id, form of @forms
            #* tally completed form count
            @info.completed++ if form.payload.status is 'completed'

            regionId = Users.lookup[form.payload.evaluatee.id].regionId

            if form.payload.status is 'completed'
              hasData = true
              @byRegion[ regionId ] ?= []
              @byRegion[ regionId ].push form

              end = moment form.payload.fieldRideEnd
              end = end.add 1, 'days' #? subtract a day so time to submit is more accurate (should have timestamp on form)
              submitted = moment form.payload.firstSubmitted

              duration = moment.duration(submitted.diff(end))

              ms = duration.asMilliseconds()
              ms = 0 if ms < 0 #? let ms be 0 is negative
              @durations.push ms

              # console.log '[ duration ]', duration
              # console.log '[ ms ]', ms

              # tempTime = moment.duration(ms)
              # console.log "Days:", tempTime.days()
              # console.log "Hours:", tempTime.hours()
              # console.log "Minutes:", tempTime.minutes()

          if @durations.length
            total = @durations.reduce (a, b) -> a + b
            average = total / @durations.length
            avg = moment.duration(average)


            times =
              days: avg.days()
              hours: avg.hours()
              minutes: avg.minutes()

            # @info.timeToSubmit.inDays = Math.round(avg.asDays() * 10) / 10
            @info.timeToSubmit.inDays = avg.asDays().toFixed 2
            @info.timeToSubmit.breakdown = times

          # console.log '[ Data.forms.byRegion ]', Data.forms.byRegion

          for id, forms of @byRegion
            # console.log '[ region id ]', id

            averageRatings = []
            uniqueUser = []

            RegionalData =
              id: id
              name: Regions.lookup[id].name
              evaluator: Regions.lookup[id].manager.email
              evaluatorId: Regions.lookup[id].manager.id
              reps: 0
              totalCompleted: 0
              avgRating: 0

            #! TODO: CHECK THIS MATH - avg of points vs avg of averages
            for form in forms
              # console.log '[ form ]', form

              uniqueUser.push form.payload.evaluatee.email if form.payload.evaluatee.email not in uniqueUser

              RegionalData.totalCompleted++

              averageRatings.push form.payload.average
              avg = (averageRatings.reduce (a, b) -> a + b) / averageRatings.length
              # RegionalData.avgRating = Math.round(avg * 10) / 10
              RegionalData.avgRating = avg.toFixed 2

              RegionalData.reps = uniqueUser.length

            @tableData.push RegionalData

          ctrl.query =
            order : 'name'
            page: 1
            limit: 5
            limitOptions: [5, 10, 25, {
              label: 'All',
              value: =>
                return @tableData.length
            }]

          ctrl.noData = !hasData

          totalReps = 0
          totalReps += district.length for districtId, district of Users.lookupByDistrict
          @info.employees = totalReps

          # console.log '%c[ @info ]', 'color: lime', @info
          # console.log '%c[ @tableData ]', 'color: deeppink', @tableData

        # ---------------------------------------------------------------------------------------------------

        @calculateSeriesData = =>

          # console.log '%c[ calculateSeriesData() : @forms ]', 'color: orange', @forms

          answered = 0
          total = 0

          for id, form of @forms
            # console.log '[ form ]', form
            if form.payload.status is 'completed'
              # console.log '%c form.payload.total', 'color: aqua', form.payload.total
              answered += form.payload.numAnswered
              total += form.payload.total
              if isNaN(form.payload.total)
                console.log '%c BAD FORM ', 'background-color: red; color: white', form

          # console.error '------------------------------------'
          # console.log '[ @forms ]', @forms
          # console.log '[ answered ]', answered
          # console.log '[ total ]', total
          # console.log '[ total/answered ]', answered/total
          # console.log '[ total/answered % ]', (answered/total) * 100
          # console.log '[ total/answered % ]', (answered/total) * @baseline


          # proficiency = (answered/total) * @baseline
          if answered is 0
            proficiency = 0
            difference = @baseline
            @avgProficiency = "N/A"
          else
            proficiency = total/answered
            difference = @baseline - proficiency
            # @avgProficiency = Math.round(proficiency * 10) / 10
            @avgProficiency = proficiency.toFixed 2

          # console.log '[ proficiency ]', proficiency
          # console.log '[ difference ]', difference

          # console.log '[ @avgProficiency ]', @avgProficiency

          seriesData =
            data: [
              ['proficiency', proficiency]
              ['difference', difference]
            ]

          # console.log '[ seriesData ]', seriesData

          hc = @config.getChartObj()
          # console.log '[ hc ]', hc

          #* fill chart data with filtered version of parsed data (timeout for forced $apply for highcharts)
          $timeout(=>
            hc.addSeries seriesData, true
          , 0)

        # ----------------------------------------------------------------------------

        @reorder = ->
          return true
          # console.log '%c[ evaluatee table : reorder() ]', 'color: deeppink'

        @paginate = ->
          return true
          # console.log '%c[ evaluatee table : paginate() ]', 'color: yellow'

        @openMenu = ($mdMenu, ev) ->
          $mdMenu.open ev

        @viewEmployeeData = (ev, id) ->
          # console.log '[ viewEmployeeData ]', id
          Users.setActive id

        @viewEmployeeFCRs = (ev, id) ->
          # console.log '[ viewEmployeeFCRs ]', id
          Forms.openFlyout(id)

        @viewDistrictData = (ev, id) ->
          # console.log '[ viewDistrictData ]', id
          Users.setActive id

        @viewRegionData = (ev, id) ->
          # console.log '[ viewRegionData ]', id
          Users.setActive id

        return true

      # =========================================================================================================
    }
