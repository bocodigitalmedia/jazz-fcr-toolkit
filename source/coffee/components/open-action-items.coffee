module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'openActionItems', {
      replace: true
      transclude: true
      templateUrl: 'components/open-action-items.html'
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
          ctrl.noData = !Data.forms.actionItemsByStatus?['inprogress']?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          competenciesLookup =
            precall: "Pre-Call Planning"
            rapport: "Opening/Establishes Rapport"
            questioning: "Effective Questioning"
            positioning: "Product Positioning"
            objections: "Handling Objections"
            commitment: "Gaining Commitment"
            analysis: "Post-Call Analysis"
            knowledge: "Product / Scientific Knowledge"
            business: "Business Analytics and Planning"
            effectiveness: "Team and Leadership Effectiveness"

          statusLookup =
            inprogress: "In Progress"
            completed: "Completed"
            cancelled: "Cancelled"

          openActionItems = angular.copy Data.forms.actionItemsByStatus.inprogress
          data = []
          for actionItemId, actionItem of openActionItems

            continue if Data.forms.all[ actionItem.submissionId ].payload.status is 'saved'
            user = Users.lookup[ actionItem.userId ]

            end = moment()
            submitted = moment actionItem.createdAt
            duration = end.diff(submitted, 'days') + 1

            obj =
              repId: actionItem.userId
              repName: Users.getName user
              dateAssigned: actionItem.createdAt
              competencyAssigned: competenciesLookup[ actionItem.competencyList ]
              status: statusLookup[ actionItem.status ]
              daysOpen: duration

            data.push obj

          ctrl.tableData = data

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

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }