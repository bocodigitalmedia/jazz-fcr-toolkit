module.exports = (angular, defaults) ->
  angular.module defaults.app.name
    .factory 'Districts', [
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

        Districts =
          all: []
          allManagers: []
          lookup: []
          lookupByManagerId: []

          #~ ================================================================================================
          #~ GET ALL
          #~ ================================================================================================

          getAll: () ->

            localVerbose = false

            #* set up a promise
            deferred = $q.defer()

            # start with an array of known districts
            @all = angular.copy defaults.activeDistricts

            # get all the managers of all districts because delphire has it set up this way
            @allManagers = Firebase.getRootObject 'managerOrganizationAssociation', 'organizationManager'

            # reset lookup array, which will be users by id with all their info, organization etc
            @lookup = []
            @lookupByManagerId = []

            # load all users, get their ids, use ids to get more info about each user
            @allManagers.$loaded().then () =>

              console.log '%c @allManagers ', 'background-color: red; color: #000', @allManagers if localVerbose

              # loop all the organizations (which each have a single string property, managerId)
              for organizationId, managerId of $firebaseUtils.toJSON(@allManagers)

                console.log '------' if localVerbose
                console.log '%c organizationId ', 'background-color: red; color: #000', organizationId if localVerbose
                console.log '%c managerId ', 'background-color: lime; color: #000', managerId if localVerbose

                # try to add to district
                district = @all[ organizationId ]
                district.manager = Users.lookup[ managerId ] if district?
                console.log '%c district ', 'background-color: lime; color: #000', district if localVerbose

              # now loop all our districts and add them to our lookup arrays for convenience later
              for districtId, district of @all

                console.log '------' if localVerbose
                console.log '%c districtId ', 'background-color: red; color: #000', districtId if localVerbose
                console.log '%c district ', 'background-color: lime; color: #000', district if localVerbose
                @lookup[ district.id ] = district
                @lookupByManagerId[ district.manager.id ] = district

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