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
                fbToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik1UVXhNa1pCUWpFd1F6QTRNRVJDT0RJNE5VWkVNVFJGTnpBelEwSkdNemxETURNMU5FSkdSUSJ9.eyJpc3MiOiJodHRwczovL2phenotcGhhcm1hY2V1dGljYWxzLmF1dGgwLmNvbS8iLCJzdWIiOiJnb29nbGUtYXBwc3xlcmljLmVtbW9uc0Bib2NvZGlnaXRhbC5jb20iLCJhdWQiOlsiaHR0cHM6Ly9pYW0uamF6enRyYWluLmRlbHBoaXJlLmlvIiwiaHR0cHM6Ly9qYXp6LXBoYXJtYWNldXRpY2Fscy5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTgxNjE5MjkwLCJleHAiOjE1ODE2MjY0OTAsImF6cCI6Ilp5S3pCWWF5M0xZWllQbklhWUk0OEJNSExpbW5zU0VPIiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBlbWFpbCJ9.R20-_RKQyZxEUsOBonI3JIvO5r0nVhxWWJbMn2d0wX_2wb3XUz7JkI6YZ4nhAarH5cOLvxssJv76HEvuDYN2LILhK5Y4HBkTOghvKcY-jzjX9WfD8NqgWGAwWB7z4BmbzzP7bHJEis-9h3iJnWuGSqr56RSHXRmFe7d3FFAt6RJiDsGJW9Q5IyXy7ujHt7WGED-1vZ8a4GPuLF52Uv17bejdjpkV8MG26Q5aQveya29pKtrBFGkz1ciT1hwqG3C0R3tTMLL8iIToYWmn_BtfVAIuL-klcN2ZAnQMZQ1Ri-2Rmpf0i2Yynh4oGbYxPOrfJAKmlzLWlkl2mxak2UOm4Q"

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
