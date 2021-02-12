module.exports = (angular, defaults) ->
  angular.module defaults.app.name
    .factory 'Regions', [
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

        Regions =
          all: []
          allManagers: []
          lookup: []
          lookupByManagerId: []

          #~ ================================================================================================
          #~ GET ALL
          #~ ================================================================================================

          getAll: () ->

            localVerbose = true

            #* set up a promise
            deferred = $q.defer()

            # start with an array of known districts
            @all = angular.copy defaults.activeRegions

            # get all the managers of all districts because delphire has it set up this way
            @allManagers = Firebase.getRootObject 'managerOrganizationAssociation', 'organizationManager'

            # reset lookup array, which will be users by id with all their info, organization etc
            @lookup = []
            @lookupByManagerId = []

            # load all users, get their ids, use ids to get more info about each user
            @allManagers.$loaded().then () =>

              console.log '%c @all', 'background-color: darkviolet; color: #000', @all if localVerbose
              console.log '%c @allManagers', 'background-color: darkviolet; color: #000', @allManagers if localVerbose

              # loop all the organizations (which each have a single string property, managerId)
              for organizationId, managerId of $firebaseUtils.toJSON(@allManagers)

                # try to add to region
                region = @all[ organizationId ]
                region.manager = Users.lookup[ managerId ] if region?

                console.log '%c ---------', 'color: red' if localVerbose
                console.log '%c organizationId', 'background-color: red; color: #000', organizationId if localVerbose
                console.log '%c managerId', 'background-color: red; color: #000', managerId if localVerbose
                console.log '%c region', 'background-color: red; color: #000', region if localVerbose
                console.log '%c Users.lookup[ managerId ]', 'background-color: red; color: #000', Users.lookup[ managerId ] if localVerbose

              # now loop all our regions and add them to our lookup arrays for convenience later
              for regionId, region of @all
                @lookup[ region.id ] = region
                console.log '%c ---------', 'color: aqua' if localVerbose
                console.log '%c region', 'color: aqua', region if localVerbose
                console.log '%c region.manager', 'color: aqua', region.manager if localVerbose
                console.log '%c region.manager.id', 'color: aqua', region.manager.id if localVerbose
                @lookupByManagerId[ region.manager.id ] = region

              if Users.active.group.super
                @lookupByManagerId[ Users.active.id ] = @all[ Object.keys(@all)[0] ]

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