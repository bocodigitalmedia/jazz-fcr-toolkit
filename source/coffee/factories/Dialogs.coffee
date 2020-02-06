module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .factory 'Dialogs', [
      '$rootScope'
      '$mdDialog'
      (
        $rootScope
        $mdDialog
      ) ->

        Dialogs =

          # ------------------------------------------------------------------------

          confirm: (ev) ->
            confirm = $mdDialog.confirm()
              .title('Confirm Test Title')
              .textContent('Confirm Test Content')
              .ariaLabel('ConfirmTestLabel')
              .targetEvent(ev)
              .ok('Yes')
              .cancel('No')

            $mdDialog.show(confirm).then (=>
              return true
            ), ->
              return false

          # ------------------------------------------------------------------------

          changeView: (ev) ->
            console.log '%c[ Dialogs ] %c(changeView)', 'color: pink', 'color: #BDC6CF'

            $mdDialog.show
              locals: { category: 'change' }
              controller: 'Dialog'
              templateUrl: 'dialogs/change-view.html'
              parent: angular.element(document.body)
              targetEvent: ev
              clickOutsideToClose: true
              onComplete: =>
                console.log '[ changeView dialog onComplete ]'

          # ------------------------------------------------------------------------

          exportData: (ev) ->
            console.log '%c[ Dialogs ] %c(exportData)', 'color: pink', 'color: #BDC6CF'

            $rootScope.exportRange =
              dateStart: null
              dateEnd: null

            $mdDialog.show
              locals: {}
              controller: 'ExportController'
              templateUrl: 'dialogs/export-data.html'
              parent: angular.element(document.body)
              targetEvent: ev
              clickOutsideToClose: true


          # ------------------------------------------------------------------------

          acceptRejectFCR: (ev, action, form) ->
            console.log '%c[ action ]', 'color: deeppink', action

            $mdDialog.show(
              locals: { form: form }
              controller: 'Dialog'
              templateUrl: 'dialogs/fcr-' + action + '.html'
              parent: angular.element(document.body)
              targetEvent: ev
              clickOutsideToClose: true
            ).then ((resp) =>
              return true
            ), ->
              return false

          # ------------------------------------------------------------------------

          success: (ev, action) ->
            console.log '%c[ action ]', 'color: deeppink', action

            $mdDialog.show(
              locals: { action: action }
              controller: 'Dialog'
              templateUrl: 'dialogs/success.html'
              parent: angular.element(document.body)
              targetEvent: ev
              clickOutsideToClose: true
            ).then ((resp) =>
              return true
            ), ->
              return false

    ]
