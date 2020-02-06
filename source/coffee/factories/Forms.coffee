module.exports = (angular, defaults) ->
  angular.module defaults.app.name
    .factory 'Forms', [
      '$q'
      '$rootScope'
      '$timeout'
      '$window'
      'Email'
      'Data'
      'Firebase'
      'Users'
      'Dialogs'
      (
        $q
        $rootScope
        $timeout
        $window
        Email
        Data
        Firebase
        Users
        Dialogs
      ) ->

        Forms =

          active: null            # full form object of open form
          selectedUserId: null    # userId of the open form
          selectedUserEmail: null # email of the open user
          selectedFormId: null    # submissionId of the open form
          formOpen: false         # flyout is active AND form showing
          formListOpen: false     # flyout is active but ONLY showing list
          formPrintable: false    # display and hide form for print css
          lastCompletedFCR: false # date of FCR completed PRIOR to the open one

          # ------------------------------------------------------------------------

          openForm: (userId, formId) ->

            # set the active form
            @active = Data.forms.all[ formId ]

            # store the ids
            @selectedFormId = formId
            @selectedUserId = userId
            @selectedUserEmail = Users.lookup[ @selectedUserId ].email

            # open the form and the flyout
            @formOpen = true
            @formListOpen = true

            # gather last completed date
            ts = @active.payload.timestamp
            userForms = Data.forms.byEvaluatee[ @selectedUserEmail ]

            # create array of all timestamps
            arr = []
            arr.push formData.payload.timestamp for formId, formData of userForms

            # determine last completed fcr
            if arr.length <= 1
              @lastCompletedFCR = '-'
            else
              arr.sort()
              pos = arr.indexOf ts
              @lastCompletedFCR = if pos is 0 then '-' else arr[ pos - 1 ]

            $rootScope.$broadcast 'formDataReady'

            # console.log '[ Forms ] (openForm) Open form'
            # console.log '[ Forms ] (openForm) @selectedFormId', @selectedFormId
            # console.log '[ Forms ] (openForm) @selectedUserId', @selectedUserId
            # console.log '[ Forms ] (openForm) @selectedUserEmail', @selectedUserEmail
            # console.log '[ Forms ] (openForm) @active', @active

          # ------------------------------------------------------------------------

          openFlyout: (userId) ->

            # store the ids
            @selectedUserId = userId
            @selectedUserEmail = Users.lookup[ @selectedUserId ].email

            # open the form and the flyout
            @formListOpen = true

            $rootScope.$broadcast 'formDataReady'

          # ------------------------------------------------------------------------

          printForm: (userId, formId) ->

            # set the active form
            @active = Data.forms.all[ formId ]

            # store the ids
            @selectedFormId = formId
            @selectedUserId = userId
            @selectedUserEmail = Users.lookup[ @selectedUserId ].email

            # make the form displayable via print css
            # @formOpen = true
            # @formListOpen = true
            @formPrintable = true

            $rootScope.$broadcast 'formPrintReady'

          # ------------------------------------------------------------------------

          acceptReject: (ev, action) =>

            #* set up a promise
            deferred = $q.defer()

            Dialogs.acceptRejectFCR(ev, action).then (resp) =>
              console.log '%c[ resp ]', 'color: lime', action, resp

              return if !resp

              console.log '%c[ Forms.active ]', 'color: deeppink', Forms.active

              form = Firebase.getObject 'userData', Forms.active.payload.evaluator.id, 'FormProgress', defaults.formId[defaults.environment], Forms.selectedFormId
              form.$loaded().then =>
                console.log '[ selected FORM ]', form

                form.payload.status = action
                Forms.active.status = action

                if action is 'completed'
                  form.payload.timestamp = (new Date()).toISOString()
                  Forms.active.timestamp = (new Date()).toISOString()

                # console.error '---------------------'
                # console.log 'action', action
                # console.log 'form.payload', form.payload

                form.$save().then =>
                  console.log '[ FORM UPDATED ]', Forms.active

                  managerEmail =
                    to: if Users.activeManager?.email? then [Users.activeManager.email] else []
                    subject: 'Field Coaching Report - Rejected'
                    action: action
                    type: 'manager'
                    data: Forms.active

                  employeeEmail =
                    to: if Forms.active?.payload.evaluatee.email? then [Forms.active.payload.evaluatee.email] else []
                    subject: 'Field Coaching Report - Rejected'
                    action: action
                    type: 'employee'
                    data: Forms.active

                  switch action

                    when 'rejected'

                      Email.send(managerEmail).then () =>
                        Email.send(employeeEmail).then () =>

                          Dialogs.success(ev, action).then (resp) =>

                            Forms.close()

                            $rootScope.toolkitRefresh()

                            #* resolve the promise
                            deferred.resolve()

                    when 'completed'

                      Dialogs.success(ev, action).then (resp) =>

                        Forms.close()

                        $rootScope.toolkitRefresh()

                        #* resolve the promise
                        deferred.resolve()

            #* send back the promise
            deferred.promise

          # ------------------------------------------------------------------------

          download: (formId) ->
            console.log '%c[ DOWNLOAD FCR ]', 'color: lime', formId
            $timeout($window.print, 250)

          # ------------------------------------------------------------------------

          getMinMaxDates: (forms) ->
            dateArray = []

            for formId, form of forms
              continue if !form.payload.timestamp
              dateArray.push new Date(form.payload.timestamp)

            return
              min: new Date(Math.min dateArray...)
              max: new Date(Math.max dateArray...)

          # ------------------------------------------------------------------------

          close: () ->
            @active = null
            @selectedFormId = null
            @selectedUserId = null
            @selectedUserEmail = null
            @formOpen = false
            @formListOpen = false
            @formPrintable = false

          #~ ================================================================================================
          #~ INIT
          #~ ================================================================================================

          init: ->

            # set up a promise
            deferred = $q.defer()

            # get all user data
            # dataPromise = @getAll()

            # wait until all promises are loaded to resolve
            $q.all( [] ).then(=>

              # finish promise
              deferred.resolve()

            # catch errors in promise calls
            ).catch (error) -> console.error error

            # send back the promise
            deferred.promise

          #~ ================================================================================================
    ]
