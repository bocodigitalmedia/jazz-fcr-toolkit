module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .controller 'DashboardController', [
      '$scope'
      '$rootScope'
      '$mdDialog'
      '$timeout'
      '$mdDateRangePicker'
      'Data'
      'Dialogs'
      'Districts'
      'Forms'
      'Regions'
      'Users'
      'mdcDefaultParams'
      (
        $scope
        $rootScope
        $mdDialog
        $timeout
        $mdDateRangePicker
        Data
        Dialogs
        Districts
        Forms
        Regions
        Users
        mdcDefaultParams
      ) ->

        # moment.locale(defaults.language, $rootScope.locale.datetime)
        moment.locale('fr', $rootScope.locale.datetime)
        mdcDefaultParams({lang: 'fr', cancelText: 'annuler', todayText: 'maintenant', okText: 'ok', dayOfWeekLen: 3});

        #~ ---------------------------------------------------------------------------------
        #~ load all information that is required for the page to load
        #~ ---------------------------------------------------------------------------------

        # display throbber
        $rootScope.loading = true

        # setting rootscope for hiding scroll if Evaluees Flyout is open
        $rootScope.hideScroll = false

        # expose services to jade
        $rootScope.Data = Data
        $rootScope.Dialogs = Dialogs
        $rootScope.Districts = Districts
        $rootScope.Forms = Forms
        $rootScope.Regions = Regions
        $rootScope.Users = Users

        #~------------------------------------------------------------------------------------------
        #~ MODULE INIT
        #~------------------------------------------------------------------------------------------

        init = () ->

          $rootScope.loading = true

          # tell each individual component to prepare for data
          $scope.$broadcast 'dataLoading'

          # load the data
          Users.init()
            .then => Districts.init()
            .then => Regions.init()
            .then => Users.getSubordinates()
            .then => Users.getDescendants()
            .then => Data.init()
            .catch loadError
            .finally loadComplete                 # start the magic

        $rootScope.toolkitRefresh = () ->

          # turn on overall spinner
          $rootScope.loading = true

          # tell each individual component to prepare for data
          $scope.$broadcast 'dataLoading'

          # load the data
          Users.getSubordinates()
            .then => Data.init()
            .catch loadError
            .finally loadComplete

        #~------------------------------------------------------------------------------------------
        #~ MODULE LOAD COMPLETE/ERROR
        #~------------------------------------------------------------------------------------------

        loadLogs = () ->
          console.info '%cLOAD COMPLETE', 'color: lime'
          console.log '------------------------------------------------------'
          console.group "FACTORY DATA"
          console.log '[ defaults ]', defaults
          console.log '[ Data ]', Data
          console.log '[ Dialogs ]', Dialogs
          console.log '[ Districts ]', Districts
          console.log '[ Forms ]', Forms
          console.log '[ Regions ]', Regions
          console.log '[ Users ]', Users
          console.groupEnd()
          console.log '------------------------------------------------------'

        #~----------------------------

        loadComplete = () ->

          # kill throbber
          $rootScope.loading = false

          # log all the loaded data
          loadLogs()

          # legacy 'wait for digest cycle' fix
          $timeout ->

            # log
            # console.log '%c[ Dashboard ] initComplete: broadcast dataReady', 'color: lime'

            # let the components know they can draw their charts
            $scope.$broadcast 'dataReady'

        #~----------------------------

        loadError = (errorMsg) ->
          console.error 'Something went wrong:', errorMsg
          return

        #~------------------------------------------------------------------------------------------
        #~ HELPER FUNCTIONS
        #~------------------------------------------------------------------------------------------

        $scope.openExportModal = ->

          #TODO: makes export configuration dialog

        #~------------------------------------------------------------------------------------------
        #~ INIT
        #~------------------------------------------------------------------------------------------

        # go team go
        init()
    ]