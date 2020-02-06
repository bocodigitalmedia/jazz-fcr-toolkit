module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'fcr', {
      replace: true
      transclude: true
      templateUrl: 'components/fcr-' + defaults.brand + '.html'
      controllerAs: 'ctrl'

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Forms) ->

        # to maintain scope across promises and functions
        ctrl = @


        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->
          $rootScope.$on 'formDataReady', @setVars
          $rootScope.$on 'formPrintReady', @printForm

        # ---------------------------------------------------------------------------------------------------

        @setVars = =>
          if Forms.active?
            @data = angular.copy Forms.active.payload
            @info = angular.copy Forms.active
            $('.fcr-form').scrollTop(0)

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
