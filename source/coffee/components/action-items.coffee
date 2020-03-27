module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'actionItems', {
      replace: true
      transclude: true
      templateUrl: 'components/action-items.html'
      controllerAs: 'ctrl'

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Firebase, Forms, Data) ->

        # to maintain scope across promises and functions
        ctrl = @

        # selection of competencies for the Action Plan area
        @competency =
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

        # status choices in action items
        @actionItemStatus =
          inprogress: "In Progress"
          completed: "Completed"
          cancelled: "Cancelled"

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->
          $rootScope.$on 'actionItemsDataReady', @setVars
          $rootScope.$on 'actionItemsPrintReady', @printForm

        # ---------------------------------------------------------------------------------------------------

        @setVars = =>
          Data.getAllActionItems(Forms.selectedUserId)
          # if Forms.active?
          #   @data = angular.copy Forms.active.payload
          #   @info = angular.copy Forms.active
          #   @actionItems = []
          #   for actionItem in @data.actionItemIds
          #     @actionItems.push Data.forms.actionItems[ actionItem ]
          #   $('.fcr-form').scrollTop(0)

        # ---------------------------------------------------------------------------------------------------

        @printForm = =>
          @setVars()
          $timeout ->
            window.print()
          , 1000

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }
