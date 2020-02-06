module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .controller 'Dialog', [
      '$scope'
      '$rootScope'
      '$mdDialog'
      'locals'
      'Data'
      'Districts'
      'Regions'
      'Users'
      (
        $scope
        $rootScope
        $mdDialog
        locals
        Data
        Districts
        Regions
        Users
      ) ->

        # ------------------------------------------------------------------------
        # yes/no-cancel

        $scope.hide =  () ->
          $mdDialog.hide()

        $scope.cancel =  () ->
          $mdDialog.cancel()

        # ---------------------------------------------------------------------------------
        # change-view dialog

        $scope.initChangeView = () ->
          $scope.category = 'change'

          if !$scope.validUsers
            $scope.validUsers = []
            for userId in Users.descendants.users
              user = Users.lookup[ userId ]
              if user
                $scope.validUsers.push
                  id: user.id
                  email: user.email

            $scope.validUsers.sort (a, b) ->
              return ('' + a.email).localeCompare(b.email, 'en', { numeric: true })
              # const sortAlphaNum = (a, b) => a.localeCompare(b, 'en', { numeric: true })
              # return if a.email < b.email then -1 else 1

          if !$scope.validDistricts
            $scope.validDistricts = []
            for districtManagerId in Users.descendants.districtManagers
              district = Districts.lookupByManagerId[ districtManagerId ]
              # console.log '%c[ DISTRICT ]', 'color: yellow', district
              if district
                $scope.validDistricts.push
                  id: district.id
                  name: district.name

            $scope.validDistricts.sort (a, b) ->
              # return ('' + a.attr).localeCompare(b.attr)
              return if a.name < b.name then -1 else 1

          if !$scope.validRegions
            $scope.validRegions = []
            for regionManagerId in Users.descendants.regionalManagers
              region = Regions.lookupByManagerId[ regionManagerId ]
              if region
                $scope.validRegions.push
                  id: region.id
                  name: region.name

            $scope.validRegions.sort (a, b) ->
              # return ('' + a.attr).localeCompare(b.attr)
              return if a.name < b.name then -1 else 1

          console.log '[ initChangeView ]'
          console.log '[ $scope.validUsers ]', $scope.validUsers
          console.log '[ $scope.validDistricts ]', $scope.validDistricts
          console.log '[ $scope.validRegions ]', $scope.validRegions

        $scope.setCategory = (category, selection) ->
          $scope.category = category
          $scope.selection = selection if selection


        $scope.selectNewCategory = (category) ->
          # console.log '%c[ category ]', 'color: yellow', category
          # console.log '%c[ selection ]', 'color: orange', $scope.selection
          switch category
            when 'evaluatee' then id = $scope.selection
            when 'district' then id = Districts.lookup[$scope.selection].manager.id
            when 'region' then id = Regions.lookup[$scope.selection].manager.id

          Users.setActive(id).then () =>
            Data.init().then () =>
              # let the components know they can draw their charts
              $rootScope.$broadcast 'dataReady'

          $mdDialog.hide()

        # ---------------------------------------------------------------------------------
        #export-data dialog



        # ---------------------------------------------------------------------------------

    ]
