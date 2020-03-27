module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'competencies', {
      replace: true
      transclude: true
      templateUrl: 'components/competencies.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        # subhead: '<'   # one way bind from parent scope

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Data, Forms, Regions, Users) ->

        # to maintain scope across promises and functions
        ctrl = @

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          ctrl.dataLoading = true
          $scope.$on 'dataLoading', => ctrl.dataLoading = true

          $scope.$on 'dataReady', @parseData

          # when changing views we redraw the whole thing, but data is already ready at that point
          @parseData() if Data.forms.byEvaluateeByStatus?

        # ---------------------------------------------------------------------------------------------------

        @parseData = ->

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byEvaluateeByStatus?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          totals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
          userTally = {}
          data = []

          for userEmail, userForms of Data.forms.byEvaluateeByStatus

            userId = Users.lookupIdByEmail[ userEmail ]
            user = Users.lookup[ userId ]
            name = Users.getName user
            numCompletedForms = 0

            userTally =
              name: name
              userId: userId
              totals: angular.copy totals

            if userForms?.completed?
              for form in userForms.completed
                numCompletedForms++
                userTally.totals[0]++ if form.payload.subs.subs1
                userTally.totals[1]++ if form.payload.subs.subs2
                userTally.totals[2]++ if form.payload.subs.subs3
                userTally.totals[3]++ if form.payload.subs.subs4
                userTally.totals[4]++ if form.payload.subs.subs5
                userTally.totals[5]++ if form.payload.subs.subs6
                userTally.totals[6]++ if form.payload.subs.subs7
                userTally.totals[7]++ if form.payload.subsections.subsection2
                userTally.totals[8]++ if form.payload.subsections.subsection3
                userTally.totals[9]++ if form.payload.subsections.subsection4

            data.push userTally if numCompletedForms isnt 0

          ctrl.tableData = data

          ctrl.noData = ctrl.tableData.length == 0

          ctrl.query =
            order : '-payload.timestamp'
            page: 1
            limit: 5
            limitOptions: [5, 10, 25, {
              label: 'All',
              value: =>
                return ctrl.tableData.length
            }]

          $timeout =>
            ctrl.dataLoading = false
          , 1000

        # ---------------------------------------------------------------------------------------------------

        @reorder = ->
          return true
          # console.log '%c[ completed table : reorder() ]', 'color: deeppink'

        @paginate = ->
          return true
          # console.log '%c[ completed table : paginate() ]', 'color: yellow', ctrl.completedForms.length

        @openMenu = ($mdMenu, ev) ->
          $mdMenu.open ev

        @viewData = (ev, id) ->
          console.log '[ viewRegionData ]', id
          Users.setActive id

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }