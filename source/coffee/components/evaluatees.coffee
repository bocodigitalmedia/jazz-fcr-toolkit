module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'evaluatees', {
      replace: true
      transclude: true
      templateUrl: 'components/evaluatees.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'
        sort: '@'
        pagination: '@'

      # =========================================================================================================

      controller: ($rootScope, $scope, $mdMenu, $timeout, Data, Users, Districts, Regions, Forms) ->

        # to maintain scope across promises and functions
        ctrl = @

        @baseline = defaults.naValue - 1

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

          # console.log '[ @forms ]', @forms

          ctrl.tableData = []
          @byEmployee = []
          @durations = []

          hasData = false

          if Users.active.group.level is 4
            @forms = angular.copy Data.forms.all

            for id, form of @forms

              if form.payload.status is 'completed'
                hasData = true
                @byEmployee[ form.payload.evaluatee.id ] ?= []
                @byEmployee[ form.payload.evaluatee.id ].push form

          else

            for id, evaluator of @forms
              # console.log '[ id ]', Users.lookup[ id ].email , Users.lookup[ id ].regionId

              for id, form of evaluator

                evalUser = Users.lookup[ form.payload.evaluator.id ]
                continue if evalUser.regionId isnt Regions.lookupByManagerId[ Users.active.id ].id

                if form.payload.status is 'completed'
                  hasData = true
                  @byEmployee[ form.payload.evaluatee.id ] ?= []
                  @byEmployee[ form.payload.evaluatee.id ].push form

          # console.log '[ @byEmployee ]', @byEmployee

          showAll = !(Data.selectedGroupId?)

          for id, forms of @byEmployee

            # console.log '[ form ]', form

            completedDates = []
            averageRatings = []

            evaluatee = Users.lookup[id]
            evaluator = Districts.lookup[evaluatee.districtId].manager

            employeeData =
              evaluatee: evaluatee.email
              evaluateeId: id
              evaluator: evaluator.email
              evaluatorId: evaluator.id
              lastCompletedDate: null
              avgRating: ctrl.baseline
              minRating: ctrl.baseline
              maxRating: 0
              totalDays: 0
              totalDaysLive: 0
              totalDaysVirtual: 0
              totalDaysOther: 0
              totalCompleted: 0
              timestamp: null
              evaluateeName: Users.getName evaluatee
              evaluatorName: Users.getName evaluator

            # console.log '[ employeeData ]', employeeData

            groupId = null

            for id, form of forms

              completedDates.push form.payload.timestamp

              averageRatings.push form.payload.average

              employeeData.minRating = form.payload.ratingMin if form.payload.ratingMin < employeeData.minRating
              employeeData.maxRating = form.payload.ratingMax if form.payload.ratingMax > employeeData.maxRating

              employeeData.totalDays += form.payload.daysInField

              switch form.payload.activity.toLowerCase()
                when 'hcp face to face' then employeeData.totalDaysLive += form.payload.daysInField
                when 'hcp virtual' then employeeData.totalDaysVirtual += form.payload.daysInField
                when 'hcp other' then employeeData.totalDaysOther += form.payload.daysInField

              employeeData.totalCompleted++

              employeeData.timestamp = form.payload.timestamp

              groupId = form.payload.evaluatee.groupId

            orderedDates = completedDates.sort (a, b) ->
              return Date.parse(a) > Date.parse(b)

            employeeData.lastCompletedDate = orderedDates[0]
            avg = (averageRatings.reduce (a, b) -> a + b) / averageRatings.length
            # employeeData.avgRating = Math.round(avg * 10) / 10
            employeeData.avgRating = avg.toFixed 2

            ctrl.tableData.push employeeData if showAll or (Data.selectedGroupId? and groupId is Data.selectedGroupId)

          sort = 'evaluatee'
          sort = '-avgRating' if ctrl.sort is 'rating'

          ctrl.query =
            order : sort
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

          # console.log '%c[ ctrl.tableData ]', 'color: lime', ctrl.tableData

        # ----------------------------------------------------------------------------

        @viewEmployeeData = (id) ->
          # console.log '[ viewEmployeeData ]', id
          Users.setActive id

        @viewEmployeeFCRs = (id) ->
          # console.log '[ viewEmployeeFCRs ]', id
          Forms.openFlyout(id)

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