module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .directive 'choices', (constants) ->
      {
        restrict: 'E'
        scope:
          questionNum: '@'
          answer: '=ngModel'
        templateUrl: 'directives/choices.html'
        replace: true
        transclude: true

        # =========================================================================================================

        # bottom up, after dom is rendered
        # http://www.bennadel.com/blog/2603-directive-controller-and-link-timing-in-angularjs.htm

        link: (scope, element, attributes) ->

          scope.set = (answerNum) ->
            scope.answer = answerNum
            console.log "************ competency answer tapped: " + scope.answer
            return

          scope.isAnswer = (answerNum) ->
            return scope.answer == answerNum
          return

        # =========================================================================================================

        # top down, before dom is rendered
        # http://www.bennadel.com/blog/2603-directive-controller-and-link-timing-in-angularjs.htm
        controller: ($scope, $rootScope, $location) ->

          # --------------------------------------------------------------------------------------------
          # do something
          init = () ->

            $scope.numChoices = constants.NUM_CHOICES

            return

          # --------------------------------------------------------------------------------------------

          init()

          return
      }