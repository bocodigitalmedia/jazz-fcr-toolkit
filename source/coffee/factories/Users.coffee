module.exports = (angular, defaults) ->
  angular.module defaults.app.name
    .factory 'Users', [
      '$injector'
      '$rootScope'
      '$q'
      '$http'
      '$firebaseUtils'
      'Firebase'
      (
        $injector
        $rootScope
        $q
        $http
        $firebaseUtils
        Firebase
      ) ->

        Users =
          active: {}
          all: []
          subordinates: []
          lookup: []
          lookupIdByEmail: []
          lookupByDistrict: []
          lookupByRegion: []
          loggedIn: null        # TODO: remove?      # will hold logged in user in case we switch to RBL view
          superUser: false      # TODO: remove?
          viewAsRbl: false      # TODO: remove?

          getName: (user) ->
            if user.name
              return user.name
            else
              if user.givenName && user.familyName
                return user.givenName + ' ' + user.familyName
              else
                return user.email

          #~ ================================================================================================
          #~ GET USER
          #~ ================================================================================================

          getUserLocal: ->

            switch defaults.brand + '-' + defaults.environment

              #! ---------------------------
              #! SLEEP PRODUCTION          -
              #! ---------------------------

              when 'sleep-production'

                @active =

                  switch defaults.testUserSleep

                    #? SALES REP (LEVEL 1)

                    when 'rep1-district1'
                      id: '-Lzlm3jE_d6GEMHVQq8B'
                      name: 'Rep 1 District 1'
                      email: 'boco.rep1.district1@gmail.com'
                      mgrEmail: 'boco.manager1.district1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-MUiSC_ADzZKAOV5APWO'
                      username: 'rep1-district1'
                      organization: '-M03BTgcsR1xpi8H6w-7'

                    when 'rep2-district1'
                      id: '-LzlmBywBOy4GuOZKUAG'
                      name: 'Rep 2 District 1'
                      email: 'boco.rep2.district1@gmail.com'
                      mgrEmail: 'boco.manager1.district1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-MUiS1vC2-ARhE99QGvk'
                      username: 'rep2-district1'
                      organization: '-M03BTgcsR1xpi8H6w-7'

                    when 'rep3-district1'
                      id: '-LzlmK9LTtWofIcfu_M4'
                      name: 'Rep 3 District 1'
                      email: 'boco.rep3.district1@gmail.com'
                      mgrEmail: 'boco.manager1.district1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-MUiS1vC2-ARhE99QGvk'
                      username: 'rep3-district1'
                      organization: '-M03BTgcsR1xpi8H6w-7'

                    when 'rep1-district2'
                      id: '-LzlnOC86t3ru5T82CTT'
                      name: 'Rep 1 District 2'
                      email: 'boco.rep1.district2@gmail.com'
                      mgrEmail: 'boco.manager2.district2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-MUo0YnEn0KppnGI2MKE'
                      username: 'rep1-district2'
                      organization: '-M03BVeWmqPCtySIrzgP'

                    when 'rep2-district2'
                      id: '-LzlnTy8zJFZVGqaa4xP'
                      name: 'Rep 2 District 2'
                      email: 'boco.rep2.district2@gmail.com'
                      mgrEmail: 'boco.manager2.district2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-MUiSC_ADzZKAOV5APWO'
                      username: 'rep2-district2'
                      organization: '-M03BVeWmqPCtySIrzgP'

                    when 'rep3-district2'
                      id: '-Lzln_SbXBOaUpRkOtUV'
                      name: 'Rep 3 District 2'
                      email: 'boco.rep3.district2@gmail.com'
                      mgrEmail: 'boco.manager2.district2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-MUiS1vC2-ARhE99QGvk'
                      username: 'rep3-district2'
                      organization: '-M03BVeWmqPCtySIrzgP'


                    #? DISTRICT MANAGER (LEVEL 2)

                    when 'manager1-district1'
                      id: '-LzlmRXnvyLOZTUbKKEO'
                      name: 'Manager 1 District 1'
                      email: 'boco.manager1-district1@gmail.com'
                      mgrEmail: 'boco.regional.manager1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BCiWABXAUuo2xEoU'
                      username: 'manager1-district1'
                      organization: '-M03BXyv8l_rQZJqjW9F'

                    when 'manager2-district2'
                      id: '-LzlnqPruZjFhPS8Ab0F'
                      name: 'Manager 2 District 2'
                      email: 'boco.manager2.district2@gmail.com'
                      mgrEmail: 'boco.regional.manager2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BCiWABXAUuo2xEoU'
                      username: 'manager2-district2'
                      organization: '-M03B_4wAvDCNicrj2RW'

                    #? REGIONAL USER (LEVEL 3)

                    when 'regional-manager-1'
                      id: '-M-QTRVGC13ZFE9YePFm'
                      name: 'Regional Manager 1'
                      email: 'boco.regional.manager1@gmail.com'
                      mgrEmail: 'boco.national.director@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BGAcmENfAf5jdq93'
                      username: 'regional-manager-1'
                      organization: '-M03Bq3CZoyZsNUo0i-D'

                    when 'regional-manager-2'
                      id: '-M-QN0ADBO86ebiOInsf'
                      name: 'Regional Manager 2'
                      email: 'boco.regional.manager2@gmail.com'
                      mgrEmail: 'boco.national.director@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BGAcmENfAf5jdq93'
                      username: 'regional-manager-2'
                      organization: '-M03Bq3CZoyZsNUo0i-D'

                    when 'fred-kalush'
                      id: '-MGoRk8F-OI9GETce7Mk'
                      name: 'FRED KALUSH'
                      email: 'frederick.kalush@jazzpharma.com'
                      mgrEmail: 'dave.hirsch@jazzpharma.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-LzhVdGiGrnnPzEx6Uto'
                      username: 'fred-kalush'
                      organization: '-MR6fgloK4ZfAyw73TcR'

                    #? NATIONAL (LEVEL 4)

                    when 'national-director'
                      id: '-M-QREGos1cWmgTsDoeM'
                      name: 'National Director'
                      email: 'boco.national.director@gmail.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BLyXd0n-QzSKbYEu'
                      username: 'national-director'
                      organization: '-M03Bq3CZoyZsNUo0i-D'

                    #? SUPER USER (LEVEL 4)

                    when 'boco-super-emmons'
                      id: '-LyeUJIasLRkbCD6R-eW'
                      name: 'Boco Super User'
                      email: 'eric.emmons@bocodigital.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-Lydv3QoOrsCWuVJ5EUG'
                      username: 'boco-super-emmons'
                      organization: '-Lye-Zvt1ifjQy4TMJD7'

                    when 'boco-super-mcdonald'
                      id: '-LyebVLWHLKy0hH40cTt'
                      name: 'Boco Super User'
                      email: 'stephen.mcdonald@bocodigital.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-Lydv3QoOrsCWuVJ5EUG'
                      username: 'boco-super-mcdonald'
                      organization: '-Lye-Zvt1ifjQy4TMJD7'

                    when 'boco-super-gabe'
                      id: '-LydsZTU3_SKB_yGZXl2'
                      name: 'Boco Super User'
                      email: 'gabe.steriti@bocodigital.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-Lydv3QoOrsCWuVJ5EUG'
                      username: 'boco-super-gabe'
                      organization: '-Lye-Zvt1ifjQy4TMJD7'

              #! ---------------------------
              #! HEMONC PRODUCTION         -
              #! ---------------------------

              when 'hemonc-production'

                @active =

                  switch defaults.testUserHemonc

                    #? SALES REP (LEVEL 1)

                    when 'rep1-district1'
                      id: '-Lzlm3jE_d6GEMHVQq8B'
                      name: 'Rep 1 District 1'
                      email: 'boco.rep1.district1@gmail.com'
                      mgrEmail: 'boco.manager1.district1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03B4-G4OgGYz4dnjVt'
                      username: 'rep1-district1'
                      organization: '-M03BTgcsR1xpi8H6w-7'

                    when 'rep2-district1'
                      id: '-LzlmBywBOy4GuOZKUAG'
                      name: 'Rep 2 District 1'
                      email: 'boco.rep2.district1@gmail.com'
                      mgrEmail: 'boco.manager1.district1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03B4-G4OgGYz4dnjVt'
                      username: 'rep2-district1'
                      organization: '-M03BTgcsR1xpi8H6w-7'

                    when 'rep3-district1'
                      id: '-LzlmK9LTtWofIcfu_M4'
                      name: 'Rep 3 District 1'
                      email: 'boco.rep3.district1@gmail.com'
                      mgrEmail: 'boco.manager1.district1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03B4-G4OgGYz4dnjVt'
                      username: 'rep3-district1'
                      organization: '-M03BTgcsR1xpi8H6w-7'

                    when 'rep1-district2'
                      id: '-LzlnOC86t3ru5T82CTT'
                      name: 'Rep 1 District 2'
                      email: 'boco.rep1.district2@gmail.com'
                      mgrEmail: 'boco.manager2.district2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03B4-G4OgGYz4dnjVt'
                      username: 'rep1-district2'
                      organization: '-M03BVeWmqPCtySIrzgP'

                    when 'rep2-district2'
                      id: '-LzlnTy8zJFZVGqaa4xP'
                      name: 'Rep 2 District 2'
                      email: 'boco.rep2.district2@gmail.com'
                      mgrEmail: 'boco.manager2.district2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03B4-G4OgGYz4dnjVt'
                      username: 'rep2-district2'
                      organization: '-M03BVeWmqPCtySIrzgP'

                    when 'rep3-district2'
                      id: '-Lzln_SbXBOaUpRkOtUV'
                      name: 'Rep 3 District 2'
                      email: 'boco.rep3.district2@gmail.com'
                      mgrEmail: 'boco.manager2.district2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03B4-G4OgGYz4dnjVt'
                      username: 'rep3-district2'
                      organization: '-M03BVeWmqPCtySIrzgP'


                    #? DISTRICT MANAGER (LEVEL 2)

                    when 'manager1-district1'
                      id: '-LzlmRXnvyLOZTUbKKEO'
                      name: 'Manager 1 District 1'
                      email: 'boco.manager1-district1@gmail.com'
                      mgrEmail: 'boco.regional.manager1@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BCiWABXAUuo2xEoU'
                      username: 'manager1-district1'
                      organization: '-M03BXyv8l_rQZJqjW9F'

                    when 'manager2-district2'
                      id: '-LzlnqPruZjFhPS8Ab0F'
                      name: 'Manager 2 District 2'
                      email: 'boco.manager2.district2@gmail.com'
                      mgrEmail: 'boco.regional.manager2@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BCiWABXAUuo2xEoU'
                      username: 'manager2-district2'
                      organization: '-M03B_4wAvDCNicrj2RW'

                    #? REGIONAL USER (LEVEL 3)

                    when 'regional-manager-1'
                      id: '-M-QTRVGC13ZFE9YePFm'
                      name: 'Regional Manager 1'
                      email: 'boco.regional.manager1@gmail.com'
                      mgrEmail: 'boco.national.director@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BGAcmENfAf5jdq93'
                      username: 'regional-manager-1'
                      organization: '-M03Bq3CZoyZsNUo0i-D'

                    when 'regional-manager-2'
                      id: '-M-QN0ADBO86ebiOInsf'
                      name: 'Regional Manager 2'
                      email: 'boco.regional.manager2@gmail.com'
                      mgrEmail: 'boco.national.director@gmail.com'
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BGAcmENfAf5jdq93'
                      username: 'regional-manager-2'
                      organization: '-M03Bq3CZoyZsNUo0i-D'

                    #? NATIONAL (LEVEL 4)

                    when 'national-director'
                      id: '-M-QREGos1cWmgTsDoeM'
                      name: 'National Director'
                      email: 'boco.national.director@gmail.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-M03BLyXd0n-QzSKbYEu'
                      username: 'national-director'
                      organization: '-M03Bq3CZoyZsNUo0i-D'

                    #? SUPER USER (LEVEL 4)

                    when 'boco-super-emmons'
                      id: '-LyeUJIasLRkbCD6R-eW'
                      name: 'Boco Super User'
                      email: 'eric.emmons@bocodigital.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-Lydv3QoOrsCWuVJ5EUG'
                      username: 'boco-super-emmons'
                      organization: '-Lye-Zvt1ifjQy4TMJD7'

                    when 'boco-super-mcdonald'
                      id: '-LyebVLWHLKy0hH40cTt'
                      name: 'Boco Super User'
                      email: 'stephen.mcdonald@bocodigital.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-Lydv3QoOrsCWuVJ5EUG'
                      username: 'boco-super-mcdonald'
                      organization: '-Lye-Zvt1ifjQy4TMJD7'

                    when 'boco-super-gabe'
                      id: '-LydsZTU3_SKB_yGZXl2'
                      name: 'Boco Super User'
                      email: 'gabe.steriti@bocodigital.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-Lydv3QoOrsCWuVJ5EUG'
                      username: 'boco-super-gabe'
                      organization: '-Lye-Zvt1ifjQy4TMJD7'

                    when 'roddy-mcilwain'
                      id: '-Lzhl7ys-TgHOkT6XJY8'
                      name: 'Roddy Mcilwain'
                      email: 'roddy.mcilwain@jazzpharma.com'
                      mgrEmail: null
                      avatar: 'http://bocoweb.bocodigital.com/boco-avatar.png'
                      groupId: '-Lzhjc1dGSoz2316nOSk'
                      username: 'boco-super-gabe'
                      organization: '-M5wItiXmCUeFq5ji8E8'

          # ------------------------------------------------------------------------

          getUserDelphire: () ->

            @active =
              id: window.Delphire.currentUser.id
              name: window.Delphire.currentUser.name
              email: window.Delphire.currentUser.email
              mgrEmail: window.Delphire.currentUser.managerEmailAddress
              avatar: if window.Delphire.currentUser.picture? then window.Delphire.currentUser.picture else ''
              groupId: window.Delphire.currentUser.groupId
              username: if window.Delphire.currentUser.nickname? then window.Delphire.currentUser.nickname else ''

          # ------------------------------------------------------------------------

          getUserDetails: () ->

            # TODO: we dont need these anymore, find and kill in code
            @active.deviceToken =  ''
            @active.title =  ''

            # TODO: REGION/HIERARCHY
            @active.regionId ?=  ''

            # get their group info from defaults based on groupId
            @active.group = defaults.activeGroups[ @active.groupId ] if defaults.activeGroups

            # back up the logged in user in case we switch to a different view
            # @loggedIn = angular.copy @active

            # see if we're a superuser or not
            # TODO: remove this and using better hierarchy
            # @superUser = (@active.groupId isnt defaults.rblRegion) and (@active.groupId isnt defaults.testRegion)
            @superUser = false

          # ------------------------------------------------------------------------

          getUser: () ->

            # if we're local
            switch defaults.isDelphire
              when false then  @getUserLocal()      # smoke and mirrors a local user
              when true then @getUserDelphire()   # pull user from delphire

            # tweak the user object and add properties we need etc
            @getUserDetails()

            # return a promise
            $q.when()

          #~ ================================================================================================
          #~ GET SUBORDINATES
          #~ ================================================================================================

          getDescendants: () ->

            Districts = $injector.get 'Districts'

            user = if @loggedIn then @loggedIn else @active

            @descendants =
              users: []
              districtManagers: []
              regionalManagers: []

            level = user.group.level
            level = if defaults.hasRegions is false and user.group.level is 3 then 4 else user.group.level
            # level = if defaults.brand is 'vaccines' and user.group.level is 3 then 4 else user.group.level

            switch level

              # district manager
              when 2

                # each subordinate is a manager, so get their users
                for repInfo in @subordinates

                  # get all members of this district and put them into descendant users
                  @descendants.users.push repInfo.id

              # regional manager
              when 3

                console.log '%c @subordinates ', 'background-color: red; color: #000', @subordinates

                # each subordinate is a manager, so get their users
                for dmInfo in @subordinates

                  console.log '%c USER WITH UNDERSCORE IGNORED:', 'background-color: red; color: #000', user if dmInfo.id[0] is '_'
                  continue if dmInfo.id[0] is '_' #! SNM UNDERSCORE ID FIX

                  # get the full info for the dm (dmInfo is stubs)
                  dm = @lookup[ dmInfo.id ]

                  # add this district id to district list
                  @descendants.districtManagers.push dm.id

                  # get the district so we know its id
                  district = Districts.lookupByManagerId[ dm.id ]

                  # get all members of this district and put them into descendant users
                  @descendants.users = @descendants.users.concat @lookupByDistrict[ district.id ]

              # national
              when 4

                # each subordinate is a manager, so get their users
                for user in @all

                  # get the full info for the user
                  userId = @lookupIdByEmail[ user.email ]
                  user = @lookup[ userId ]

                  if user.group?.level?
                    switch user.group.level
                      when 1 then @descendants.users.push user.id
                      when 2 then @descendants.districtManagers.push user.id
                      when 3 then @descendants.regionalManagers.push user.id

          # ------------------------------------------------------------------------

          getSubordinates: () ->

            console.log '%c Users.active ', 'background-color: red; color: #000', Users.active

            Districts = $injector.get 'Districts'
            Regions = $injector.get 'Regions'

            organizationId = null

            district = Districts.lookupByManagerId[ @active.id ]
            organizationId = district.id if district?

            region = Regions.lookupByManagerId[ @active.id ]
            organizationId = region.id if region?

            organizationId = defaults.activeTeam.id if ( @active.group.level is 4 ) or ( @active.group.level is 3 and !defaults.hasRegions )
            # organizationId = defaults.activeTeam.id if ( @active.group.level is 4 ) or ( @active.group.level is 3 and defaults.brand is 'vaccines' ) or ( @active.group.level is 3 and defaults.brand is 'canada-resp' )

            @subordinates = []

            for user in @all
              if @lookup[ user.id ].organizationId is organizationId
                @subordinates.push
                  createdAt: user.createdAt
                  email: user.email
                  employmentStartDate: user.employmentStartDate
                  id: user.id
                  updatedAt: user.updatedAt

            $q.when()

          #~ ================================================================================================
          #~ INITIALS
          #~ ================================================================================================

          showInitials: (section) ->
            return false if !$rootScope.defaults.initials.active
            allowed = $rootScope.defaults.initials.included[section].levels
            return  true if $rootScope.Users.active.group.level in allowed

          getInitials: (userId) ->

            return '' if !userId?

            Groups = $injector.get 'Groups'
            Regions = $injector.get 'Regions'
            user = @lookup[userId]

            return '' if !user?

            switch defaults.initials.type
              when 'brand'
                return Groups.lookup[ user.groupId ].initials
              when 'team'
                #? employeeData.regionInitials = Regions.lookup[ form.payload.evaluator.regionIdOriginal ].initials
                return Regions.lookup[ user.regionId ].initials


          #~ ================================================================================================
          #~ GET ALL
          #~ ================================================================================================

          getAll: () ->

            #* set up a promise
            deferred = $q.defer()

            # TODO: this should start at self and build a tree not load all
            @all = Firebase.getRootArray 'users', 'byId'

            # reset lookup array, which will be users by id with all their info, organization etc
            @lookup = []
            @lookupIdByEmail = []
            @lookupByDistrict = []
            @lookupByRegion = []

            # load all users, get their ids, use ids to get more info about each user
            @all.$loaded()
              .then () => @addUserIds(@all, @lookup)
              .then () => @addUserInfo(@all, @lookup)
              .then () => @addUserOrganization(@all, @lookup)
              .then () => @addUserGroup(@all, @lookup)
              .catch @loadError
              .finally =>

                # finish promise
                deferred.resolve()

            #* send back the promise
            deferred.promise

          # ------------------------------------------------------------------------

          getAllManagers: () ->

            #* set up a promise
            deferred = $q.defer()

            # TODO: this should start at self and build a tree not load all
            allManagers = Firebase.getRootObject 'managerOrganizationAssociation', 'organizationManager'

            # load all managers, add them to defaults.activeDistricts/Regions
            allManagers.$loaded()
              .then () =>

                # go through each manager
                for organizationId, managerId of $firebaseUtils.toJSON(allManagers)

                  # try to add to district
                  district = defaults.activeDistricts[ organizationId ]
                  district.manager = @lookup[ managerId ] if district?

                  # try to add to region
                  region = defaults.activeRegions[ organizationId ]
                  region.manager = @lookup[ managerId ] if region?if region?

              .catch @loadError
              .finally =>

                # finish promise
                deferred.resolve()

            #* send back the promise
            deferred.promise

          #~ ================================================================================================
          #~ ADD USER INFORMATION TO LOOKUPS
          #~ ================================================================================================

          addUserIds: (users, lookupArray) ->

            #* set up a promise
            deferred = $q.defer()

            return $q.when() if !users? or users.length is 0

            # loop all subordinates, look them up by email, and get their ids
            promises = []
            for user in users
              promise = Firebase.getRootObject 'users', 'byEmail', Firebase.encodeKey(user.email, true)
              promises.push promise.$loaded()

            # once we have all the user ids, add them to their users
            $q.all(promises).then (data) =>

              # strip out firebase properties to get the id we need from firebase [ {id, email} ]
              idsWithEmails = []
              for user in data
                angular.forEach(user, (v, k) ->
                  email = user.$id
                  if k.indexOf('$') is -1
                    idsWithEmails.push
                      email: Firebase.decodeKey email
                      id: k
                    return false
                )

              # go through our existing users
              for user in users

                # go through idsWithEmails to find the matching email and give that user its proper id
                for idEmail in idsWithEmails
                  if user.email == idEmail.email
                    user.id = idEmail.id
                    lookupArray[ user.id ] = $firebaseUtils.toJSON(user) if lookupArray
                    @lookupIdByEmail[ user.email ] = user.id
                    break

              # finish promise
              deferred.resolve()

            #* send back the promise
            deferred.promise

          # ------------------------------------------------------------------------

          addUserInfo: (users, lookupArray) ->

            # this function only acts on lookupArray
            return $q.when() if !lookupArray

            #* set up a promise
            deferred = $q.defer()

            # get all userInfo so we can loop through
            allUserInfo = Firebase.getRootObject 'users', 'userInfo'

            # once we have all the user info, add to their lookup
            allUserInfo.$loaded().then () =>

              # go through our existing users and push them to the lookup array
              for userId, user of $firebaseUtils.toJSON(allUserInfo)
                lookupArray[ userId ].profile = $firebaseUtils.toJSON(user)

              # finish promise
              deferred.resolve()

            #* send back the promise
            deferred.promise

          # ------------------------------------------------------------------------

          addUserOrganization: (users, lookupArray) ->

            # this function only acts on lookupArray
            return $q.when() if !lookupArray or !defaults.activeDistricts or !defaults.activeRegions

            #* set up a promise
            deferred = $q.defer()

            # get all associations so we can loop through
            allUserInfo = Firebase.getRootObject 'organizationMemberAssociation', 'memberOrganizations'

            # once we have all the user info, add to their lookup
            allUserInfo.$loaded().then () =>

              # go through our existing users and give them their organization
              for userId, user of $firebaseUtils.toJSON(allUserInfo)

                # strip firebase properties and get organization id
                org = Object.keys( $firebaseUtils.toJSON(user) )[0]

                # assign ORGANIZATION to user (and set some defaults)
                angular.extend(lookupArray[ userId ],
                  organizationId: org
                  districtId: null
                  regionId: null
                )

                # determine what kind of user we have
                isRegion = ( org in Object.keys(defaults.activeRegions) )
                isDistrict = ( org in Object.keys(defaults.activeDistricts) )

                # assign district and region if org is in DISTRICT list
                if isDistrict
                  lookupArray[ userId ].districtId = org
                  lookupArray[ userId ].regionId = defaults.activeDistricts[org].region
                  @lookupByDistrict[ org ] ?= []
                  @lookupByDistrict[ org ].push userId

                # assign district and region if org is in REGION list
                if isRegion
                  lookupArray[ userId ].districtId = null
                  lookupArray[ userId ].regionId = org
                  @lookupByRegion[ org ] ?= []
                  @lookupByRegion[ org ].push userId

              # finish promise
              deferred.resolve()

            #* send back the promise
            deferred.promise

          # ------------------------------------------------------------------------

          addUserGroup: (users, lookupArray) ->

            # this function only acts on lookupArray
            return $q.when() if !lookupArray

            #* set up a promise
            deferred = $q.defer()

            # get all associations so we can loop through
            allUserInfo = Firebase.getRootObject 'groupUserAssociation', 'userGroups'

            # once we have all the user info, add to their lookup
            allUserInfo.$loaded().then () =>

              # go through our existing users and give them their group
              for userId, user of $firebaseUtils.toJSON(allUserInfo)

                # strip firebase properties and get group id
                groupId = Object.keys( $firebaseUtils.toJSON(user) )[0]

                # assign group id to user
                lookupArray[ userId ].groupId = groupId

                # assign group details to user
                lookupArray[ userId ].group = defaults.activeGroups[groupId] ? null if defaults.activeGroups?

              # finish promise
              deferred.resolve()

            #* send back the promise
            deferred.promise

          #~ ================================================================================================
          #~ USER SWITCHING
          #~ ================================================================================================

          setActive: (userId) ->
            @loggedIn = angular.copy @active if not @loggedIn
            @active = angular.copy @lookup[ userId ]
            $rootScope.toolkitRefresh()

          resetToLoggedIn: () ->
            @active = angular.copy @loggedIn
            @loggedIn = null
            $rootScope.toolkitRefresh()

          #~ ================================================================================================
          #~ INIT
          #~ ================================================================================================

          init: ->

            # set up a promise
            deferred = $q.defer()

            @getUser()
              .then => @getAll()
              .then => @getAllManagers()
              .then => @getSubordinates()
              .catch @loadError
              .finally =>

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