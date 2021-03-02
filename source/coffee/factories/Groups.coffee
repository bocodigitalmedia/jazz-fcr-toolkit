module.exports = (angular, defaults) ->
  angular.module defaults.app.name
    .factory 'Groups', [
      '$q'
      '$http'
      '$firebaseUtils'
      'Firebase'
      'Users'
      (
        $q
        $http
        $firebaseUtils
        Firebase
        Users
      ) ->

        Groups =
          all: []
          lookup: []

          #~ ================================================================================================
          #~ GET ALL
          #~ ================================================================================================

          getAll: () ->

            localVerbose = false

            #* set up a promise
            deferred = $q.defer()

            # start with an array of known districts
            @all = angular.copy defaults.activeGroups

            # reset lookup array, which will be users by id with all their info, organization etc
            @lookup = []

            # now loop all our groups and add them to our lookup arrays for convenience later
            for groupId, group of @all
              @lookup[ group.id ] = group
              console.log '%c ---------', 'color: aqua' if localVerbose
              console.log '%c group', 'color: aqua', group if localVerbose

              # finish promise
              deferred.resolve()

            #* send back the promise
            deferred.promise

          #~ ================================================================================================
          #~ INIT
          #~ ================================================================================================

          init: ->

            # set up a promise
            deferred = $q.defer()

            @getAll().then () =>

                # finish promise
                deferred.resolve()

            # send back the promise
            deferred.promise

          # ---------------------------------

          loadError: (errorMsg) ->
            console.error 'Something went wrong:', errorMsg
            return

          # ------------------------------------------------------------------------

    ]