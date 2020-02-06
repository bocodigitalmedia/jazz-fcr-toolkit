module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .factory 'Firebase', [
      '$firebaseArray'
      '$firebaseObject'
      '$q'
      (
        $firebaseArray
        $firebaseObject
        $q
      ) ->

        Firebase =

          authorized: false
          connection: null
          mainDB: null
          shardDataDB: null
          shardStateDB: null

          # ------------------------------------------------------------------------------------------
          # CONNECTION
          # ------------------------------------------------------------------------------------------

          init: (config) ->
            # firebase.initializeApp config
            Firebase.connection = firebase.initializeApp config
            Firebase.mainDB = Firebase.connection.database()

          refresh: () ->
            mainDB = firebase.database()
            tenantDB = null

          setShardData: (shard) ->
            Firebase.shardDataDB = Firebase.connection.database shard

          setShardState: (shard) ->
            Firebase.shardStateDB = Firebase.connection.database shard

          authorize: (token) ->
            deferred = $q.defer()
            if firebase.auth().currentUser
              deferred.resolve()
            else
              firebase.auth().signInWithCustomToken(token)
                .then () -> deferred.resolve()
                .catch (err) -> deferred.reject(err)
            return deferred.promise

          authorizeAnon: () ->
            deferred = $q.defer()

            if firebase.auth().currentUser
              deferred.resolve()
            else
              firebase.auth().signInAnonymously()
                .then () ->
                  deferred.resolve()
                .catch (err) -> deferred.reject(err)
            return deferred.promise


          # ------------------------------------------------------------------------------------------
          # GETTER / SETTERS
          # ------------------------------------------------------------------------------------------

          # simple firebase ref
          get: (children...) ->
            ref = Firebase.shardDataDB.ref "environments/" + defaults.environment + "/" + children.join('/')
            return ref

          getRoot: (children...) ->
            ref = Firebase.shardStateDB.ref "environment/" + defaults.environment + "/iam/state/" + children.join('/')
            return ref

          # filtered simple firebase object
          getFiltered: (filter, children...) ->
            return false if not filter.name? or not filter.value?
            ref = @get(children...).orderByChild(filter.name).equalTo(filter.value)
            return ref

          # return $firebaseArray of a ref
          getArray: (children...) ->
            return $firebaseArray @get(children...)

          # return $firebaseObject of a ref
          getObject: (children...) ->
            return $firebaseObject @get(children...)

          # return $firebaseObject of a ref
          getRootObject: (children...) ->
            return $firebaseObject @getRoot(children...)

          # return $firebaseArray of a ref
          getRootArray: (children...) ->
            return $firebaseArray @getRoot(children...)

          # filter by any property in format { name: 'region', value: 'Northeast' }
          getFilteredArray: (filter, children...) ->
            return $firebaseArray @getFiltered(filter, children...)

          # filter by any property in format { name: 'region', value: 'Northeast' }
          getFilteredObject: (filter, children...) ->
            return $firebaseObject @getFiltered(filter, children...)

          # ------------------------------------------------------------------------------------------
          # UTILITIES
          # ------------------------------------------------------------------------------------------

          # for formatting email address keys
          encodeKey: (key, atSign) ->
            key = key.replace(/\%/g, '%25').replace(/\./g, '%2E').replace(/\#/g, '%23').replace(/\$/g, '%24').replace(/\//g, '%2F').replace(/\[/g, '%5B').replace /\]/g, '%5D'
            return key if !atSign
            return key.replace(/\@/g, '%40') if atSign

          # for formatting email address keys
          decodeKey: (key) ->
            key.replace(/%40/g, '@').replace(/%25/g, '%').replace(/%2E/g, '.').replace(/%23/g, '#').replace(/%24/g, '$').replace(/%2F/g, '\\').replace(/%5B/g, '[').replace /%5D/g, ']'

          # ------------------------------------------------------------------------
    ]