json = require '../../package.json'

delphireJsNpm = require 'delphire-js-npm'

# ------------------------------------------------------------------

module.exports = [
  '$rootScope'
  '$state'
  '$timeout'
  '$q'
  'Firebase'

  (
    $rootScope
    $state
    $timeout
    $q
    Firebase

  ) ->

    init = () ->

      # throbber variable
      $rootScope.loading = true

      # versioning
      $rootScope.version = 'v' + json.version
      $rootScope.version = 'v' + json.version + ' (' + defaults.environment + ')' if defaults.environment != 'production'

      # expose to jade
      $rootScope.defaults = defaults
      $rootScope.locale = locale

      # connect to firebase
      initFirebase()

      # start the delphire load process
      initDelphire()

      # make sure we start at the dashboard
      $timeout ->
        $state.go 'dashboard' if !($state.current.name in ['', 'dashboard'])
        return

    # ---------------------------------------------------------------------------------------------------

    initFirebase = () ->

      Firebase.init
        apiKey: defaults.firebase.apiKey
        authDomain: defaults.firebase.authDomain
        databaseURL: defaults.firebase.databaseURL
        storageBucket: defaults.firebase.storageBucket
        messagingSenderId: defaults.firebase.messagingSenderId
        environment: defaults.environment

      Firebase.setShardData defaults.firebase.dataShard
      Firebase.setShardState defaults.firebase.stateShard

    # ---------------------------------------------------------------------------------------------------

    initDelphire = () ->

      # set up a promise so the dashboard (resolve) waits for delphire to load
      $rootScope.waitForDelphire = $q.defer()

      # init delphire bridge
      delphireJsNpm.delphireJS()

      # pretend delphire loaded if we're local
      if location.href.indexOf('localhost') isnt -1
        return $rootScope.waitForDelphire.resolve()

      # actually load delphire if we're not local
      Delphire.init().then ->
        $rootScope.delphireToken = window.Delphire.token
        $rootScope.delphireFBToken = window.Delphire.fbToken
        $rootScope.delphireUser = window.Delphire.currentUser
        $rootScope.waitForDelphire.resolve()

    # ---------------------------------------------------------------------------------------------------

    # make it go
    init()

    # ---------------------------------------------------------------------------------------------------

    # find any errors in resolves
    $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
      console.error '[ router service ]', error

    # ---------------------------------------------------------------------------------------------------

    return
]