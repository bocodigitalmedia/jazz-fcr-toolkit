module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'incompletes', {
      replace: true
      transclude: true
      templateUrl: 'components/incompletes.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        # subhead: '<'   # one way bind from parent scope

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Data, Districts, Groups, Forms, Regions, Users) ->

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
          ctrl.noData = !Data.forms.allByStatus?['submitted']?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          showAll = !(Data.selectedGroupId?)

          submittedForms = angular.copy Data.forms.allByStatus.submitted
          forms = []
          for formId, form of submittedForms
            form.payload.initials = Groups.lookup[ form.payload.evaluatee.groupId ].initials
            form.payload.repId = form.payload.evaluatee.id
            form.payload.repName = Users.getName form.payload.evaluatee
            form.payload.managerName = form.payload.evaluator.name
            form.payload.regionName = if form.payload.evaluator.regionId? and Regions.lookup[ form.payload.evaluator.regionId ]?.name? then Regions.lookup[ form.payload.evaluator.regionId ].name else ''
            form.payload.districtName = Districts.lookupByManagerId[ form.payload.evaluator.id ].name if form.payload.evaluator.id?
            form.payload.submissionDate = form.createdAt
            form.payload.submissionId = formId

            validGroup = ( showAll or (Data.selectedGroupId? and form.payload.evaluatee.groupId is Data.selectedGroupId) )

            validUser = false
            switch Users.active.group.level
              when 1 then validUser = true
              when 2
                evaluatee = Users.lookup[ form.payload.evaluatee.id ]
                validUser = evaluatee.districtId is Districts.lookupByManagerId[ Users.active.id ].id
              when 3
                evaluator = Users.lookup[ form.payload.evaluator.id ]
                validUser = evaluator.regionId is Regions.lookupByManagerId[ Users.active.id ].id
              when 4 then validUser = true

            forms.push form.payload if validGroup && validUser

          ctrl.tableData = forms

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

        @viewData = (ev, id) ->
          # console.log '[ viewRegionData ]', id
          Users.setActive id

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }