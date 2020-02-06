module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'employeeReview', {
      replace: true
      transclude: true
      templateUrl: 'components/employee-review.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        # subhead: '<'   # one way bind from parent scope

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Data, Users) ->

        # to maintain scope across promises and functions
        ctrl = @

        ctrl.query =
          order : '?'
          page: 1
          limit: 5
          limitOptions: [5, 10, 25, {
            label: 'All',
            value: ->
              return true
              # return someData.length
          }]

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          # console.log '[ Employee Review Component ]'
          $scope.$on 'dataReady', @parseData

          # when changing views we redraw the whole thing, but data is already ready at that point
          @parseData() if Data.forms.byEvaluateeByStatus?

        # ---------------------------------------------------------------------------------------------------

        # converts array of forms containing questions into array of questions containing all forms answers
        @parseData = ->

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byEvaluateeByStatus[ Users.active.email ]?.submitted?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          ctrl.submittedForms = Data.forms.byEvaluateeByStatus[ Users.active.email ].submitted

        # ---------------------------------------------------------------------------------------------------

        @reorder = ->
          return true
          # console.log '%c[ employee review table : reorder() ]', 'color: deeppink'

        @paginate = ->
          return true
          # console.log '%c[ employee-review table : paginate() ]', 'color: yellow'

        @openMenu = ($mdMenu, ev) ->
          $mdMenu.open ev

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }