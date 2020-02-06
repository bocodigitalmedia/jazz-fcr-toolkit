json = require '../../package.json'

module.exports = [
  '$stateProvider'
  (
    $stateProvider
  ) ->

    env = defaults.environment

    $stateProvider

      .state 'dashboard',
        url: '/'
        templateUrl: 'views/dashboard.html'
        controller: 'DashboardController'
        resolve:
          firebaseAuthorized: ['$rootScope','Firebase', '$window', ($rootScope, Firebase, $window) ->

            delphirePromise = $rootScope.waitForDelphire.promise

            delphirePromise.then () ->
              console.log "%c[ config ] (firebaseAuthorized) waitForDelphire promise resolved", 'color: lime'

              fbToken = null # grabbed from the delphire bridge

              if location.href.indexOf('localhost') isnt -1

                # emmons
                # return fbToken = ""

                # mcdonald
                return fbToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiItTFJjVFVjdEZsallJXzAxQ0JhQSIsImlhdCI6MTU1ODAyNzUyMiwiZXhwIjoxNTU4MDMxMTIyLCJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlzcyI6ImZpcmViYXNlLWFkbWluc2RrLXM0dzd3QGRlbHBoaXJlLWlvLWdzay5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsInN1YiI6ImZpcmViYXNlLWFkbWluc2RrLXM0dzd3QGRlbHBoaXJlLWlvLWdzay5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSJ9.KAofFC04-a9JdzyAN7RnYoU4kuugOU-WjJeGe-gZpWe-lph6Z1aRdNVywcVU4HwTN8r0UFRYGwmBzONcJUKoVIVnjErZUUY5l50FhxWIFSWOcmxVKBPAeMKodAGD3nRZC91h9JkYW8Dnien6eo_QXpb6Ccyf136aO_NBs40IqqIw9cqkKk9ewNbJ48_mwekRipAIxxXXtUcX3UY_PtyRUiaXfg3d8ToXMLQ8N4bFcjGN9zlWdsz3zBSD2U9p0d3CxjndKgEGCWiEzv8eSKAoxkT_Gbh2fU3fWx6ujaRG7q6HTOBlpcVMI7yNzsXRe6aI1h3vnWfLtLg8GeNrzJY12A"

              else
                # fbToken = $rootScope.delphireFBToken

              Firebase.authorizeAnon().then () ->
                console.log "%c[ config ] (firebaseAuthorized) going to dashboard", 'color: lime'
          ]

      # default state to kick them to the dashboard if they muck with the url
      .state 'otherwise',
        url: '*path'
        template: ''
        controller: ['$state',($state) ->
          $state.go 'dashboard'
        ]
]
