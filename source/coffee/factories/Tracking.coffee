module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .provider 'Tracking', () ->

      options = {}

      @configure = (props) ->
        options[key] = val for own key, val of props

      @$get = ['$q', '$rootScope', ( $q, $rootScope ) ->

        Tracking =
          queue:
            add: ({ collection, data }) ->
              if location.href.indexOf('localhost') isnt -1
                console.log '[ MOCK TRACKING ] *** Added Event to Queue ***', { collection, data }
              Tracking.queue.current[collection] = [] unless Tracking.queue.current[collection]
              Tracking.queue.current[collection].push data
            clear: () ->
              if location.href.indexOf('localhost') isnt -1
                console.log '[ MOCK TRACKING ] *** Cleared Queue ***'
              Tracking.queue.current = {}
            send: () ->
              if location.href.indexOf('localhost') isnt -1
                console.log '[ MOCK TRACKING ] *** Would Send All Events: ***', Tracking.queue.current
              else
                return Tracking.client.addEvents Tracking.queue.current if Tracking.isReady
                return Tracking.init().then () -> Tracking.client.addEvents Tracking.queue.current
            current: {}

          init: () ->
            Tracking.client = new Keen(options)
            deferred = $q.defer()
            Keen.ready () ->
              Tracking.isReady = true
              deferred.resolve()
            return deferred.promise

          keen: () ->
            obj =
              addons: [
                {
                  name: "keen:ua_parser"
                  input: { ua_string: "agent"}
                  output: "device"
                }
              ]

          # TODO: this should be everything from user object except profile
          user: () ->
            obj =
              id         : ''
              name       : ''
              email      : ''
              team       : ''
              region     : ''
              territory  : ''
              title      : ''

          track: ({ collection, data }) ->

            # add the user info
            data.user = @user()

            # add built in keen stuff
            data.keen = @keen()

            # add a few more things
            data.agent = "${keen.user_agent}"
            data.moduleName = defaults.app.name

            # if we're not local
            if location.href.indexOf('localhost') is -1

              # if tracking is ready add the event
              return Tracking.client.addEvent collection, data if Tracking.isReady

              # if it's not readay, init then add the event
              return Tracking.init().then () -> Tracking.client.addEvent collection, data

            # if we're local
            params =
              collection: collection
              data: data

            # then just log it
            console.info '[ MOCK TRACKING ]', JSON.stringify(params), params

      ]

      @
