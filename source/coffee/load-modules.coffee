module.exports = (angular, defaults) ->
  modules = [

    require './main'

    require './controllers/Dashboard'
    require './controllers/Export'
    require './controllers/Dialog'

    # require './factories/Tracking'
    require './factories/Firebase'
    require './factories/Email'
    require './factories/Data'
    require './factories/Dialogs'
    require './factories/Districts'
    require './factories/Email'
    require './factories/Forms'
    require './factories/Regions'
    require './factories/Users'

    require './directives/choices'

    require './components/fcr'
    require './components/employee-review'
    require './components/glance'
    require './components/proficiency-overall'
    require './components/evaluatees'
    require './components/evaluators'
    require './components/proficiency-section'
    require './components/integrity'
    require './components/expectations'
    require './components/completed'

    require './components/incompletes'
    require './components/competencies'
    require './components/open-action-items'

  ]
  module angular, defaults for module in modules
  angular.bootstrap document, [ defaults.app.name ]
