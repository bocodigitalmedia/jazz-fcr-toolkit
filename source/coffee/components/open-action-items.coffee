module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'openActionItems', {
      replace: true
      transclude: true
      templateUrl: 'components/open-action-items.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        # subhead: '<'   # one way bind from parent scope

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Data, Forms, Regions, Users, Districts) ->

        # to maintain scope across promises and functions
        ctrl = @

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          ctrl.dataLoading = true
          $scope.$on 'dataLoading', => ctrl.dataLoading = true

          $scope.$on 'dataReady', @parseData

          # when changing views we redraw the whole thing, but data is already ready at that point
          @parseData() if Data.forms.byEvaluateeByStatus?

        # ---------------------------------------------------------------------------------------------------

        @parseData = ->

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.actionItemsByStatus?['inprogress']?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          showAll = !(Data.selectedGroupId?)

          competenciesLookup =
            precall: "Pre-Call Planning"
            rapport: "Opening/Establishes Rapport"
            questioning: "Effective Questioning"
            positioning: "Product Positioning"
            objections: "Handling Objections"
            commitment: "Gaining Commitment"
            analysis: "Post-Call Analysis"
            knowledge: "Product / Scientific Knowledge"
            business: "Business Analytics and Planning"
            effectiveness: "Team and Leadership Effectiveness"
            other: "Other"

          statusLookup =
            inprogress: "In Progress"
            completed: "Completed"
            cancelled: "Cancelled"

          openActionItems = angular.copy Data.forms.actionItemsByStatus.inprogress
          data = []

          for actionItemId, actionItem of openActionItems

            localVerbose = false
            console.log '---' if localVerbose
            console.log '%c actionItem ', 'background-color: red; color: #000', actionItem if localVerbose
            console.log '%c user ', 'background-color: lime; color: #000', user if localVerbose

            user = Users.lookup[ actionItem.userId ]
            continue if !user?.districtId?

            continue if Data.forms.all[ actionItem.submissionId ].payload.status is 'saved'


            end = moment()
            submitted = moment actionItem.createdAt
            duration = end.diff(submitted, 'days') + 1

            obj =
              repId: actionItem.userId
              repName: Users.getName user
              dateAssigned: actionItem.createdAt
              competencyAssigned: competenciesLookup[ actionItem.competencyList ]
              status: statusLookup[ actionItem.status ]
              daysOpen: duration

            thePayload = Data.forms.all[ actionItem.submissionId ].payload
            validGroup = ( showAll or (Data.selectedGroupId? and thePayload.evaluatee.groupId is Data.selectedGroupId) )

            validUser = false
            switch Users.active.group.level
              when 1 then validUser = true
              when 2
                evaluatee = Users.lookup[ thePayload.evaluatee.id ]
                validUser = evaluatee.districtId is Districts.lookupByManagerId[ Users.active.id ].id
              when 3
                evaluator = Users.lookup[ thePayload.evaluator.id ]
                validUser = evaluator.regionId is Regions.lookupByManagerId[ Users.active.id ].id
              when 4 then validUser = true

            data.push obj if validGroup and validUser

          ctrl.tableData = data

          ctrl.query =
            order : '-payload.timestamp'
            page: 1
            limit: 5
            limitOptions: [5, 10, 25, {
              label: 'All',
              value: =>
                return ctrl.tableData.length
            }]

          $timeout =>
            ctrl.dataLoading = false
          , 1000

        # ---------------------------------------------------------------------------------------------------

        @reorder = ->
          return true
          # console.log '%c[ completed table : reorder() ]', 'color: deeppink'

        @paginate = ->
          return true
          # console.log '%c[ completed table : paginate() ]', 'color: yellow', ctrl.completedForms.length

        @openMenu = ($mdMenu, ev) ->
          $mdMenu.open ev

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }