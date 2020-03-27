module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'expectations', {
      replace: true
      transclude: true
      templateUrl: 'components/expectations.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        minQuestion: '<'  # number
        maxQuestion: '<'  # number
        height: '<'       # number

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Data, Users) ->

        # to maintain scope across promises and functions
        ctrl = @

        integrityPercent = 0

        # ---------------------------------------------------------------------------------------------------

        # limiters for chart, 0-based
        @minQuestion = if @minQuestion? then @minQuestion - 1 else 0
        @maxQuestion = if @maxQuestion? then @maxQuestion - 1 else defaults.questions.length

        # ---------------------------------------------------------------------------------------------------

        @config =
          chart:
            type: 'pie'
            width: 180
            height: 180
            backgroundColor: 'transparent'
            events:
              addSeries: (event) ->
                # console.log '[ ADD SERIES ]'
                chart = event.target
                textX = chart.plotLeft + chart.plotWidth * 0.5
                textY = chart.plotTop + chart.plotHeight * 0.5
                span = '''
                  <span id="expectationsChartCenter" style="position:absolute; text-align:center;">
                    <span style="display: inline-block; font-size: 32px; margin-left: 0.25em">''' + integrityPercent + '''</span><span style="display: inline-block; font-size: 16px; vertical-align: top; margin-top: 6px">%</span>
                    <span style="display: block; font-size: 12px">yes</span>
                  </span>'''
                $('#expectations-percentage').html span
                span = $('#expectationsChartCenter')
                span.css 'left', textX + span.width() * -0.5
                span.css 'top', textY + span.height() * -0.5
          credits:
            enabled: false
          exporting:
            enabled: false
          title:
            text: null
          subtitle:
            text: null
          tooltip:
            enabled: false
          colors: [
            '#ED4279'
            '#F8E8EE'
          ]
          plotOptions:
            pie:
              borderColor: 'transparent'
              innerSize: '65%'
              dataLabels: enabled: false
            series: states: hover: enabled: false
          series: []

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          ctrl.dataLoading = true
          $scope.$on 'dataLoading', => ctrl.dataLoading = true

          $scope.$on 'dataReady', @parseData

          # when changing views we redraw the whole thing, but data is already ready at that point
          @parseData() if Data.forms.byEvaluateeByStatus?

        # ---------------------------------------------------------------------------------------------------

        @parseData = =>
          # get the logged in user via lookup so we have extra properties (like districtId)
          user = Users.lookup[ Users.active.id ]

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byEvaluateeByStatus[ Users.active.email ]?.completed?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          # get this user's forms, which we'll loop through and convert to points
          dataset = Data.forms.byEvaluateeByStatus[ Users.active.email ].completed

          # duh
          numQuestions = ctrl.maxQuestion - ctrl.minQuestion + 1

          # store answers for each question, eg tally[question 0].answers[form1, form2, form3...]
          answerArrays = []

          # loop through each form in the dataset and store answers to each question, even NAs
          for form in dataset

            formId = form.payload.submissionId

            # first get all the answers to this form
            answers = form.payload.answers

            # TODO: remove fake news for easy testing
            # switch formId
            #   when '1226d905-cb6e-4f8e-b050-b69857f0a4e8' then answers = [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 1]
            #   when '7534c95d-5a1c-49e7-8c43-5b8fd2eb52d2' then answers = [0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
              # when 'test' then answers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]

            # then break it down by section (each instance of this component is a subset of questions) using minQuestion and maxQuestion
            slicedAnswers = answers.slice ctrl.minQuestion, ctrl.maxQuestion + 1

            # loop each answer
            for answer, i in slicedAnswers

              # make sure we have an array for this question
              answerArrays[i] ?= []

              # and push it to the answer array
              answerArrays[i].push answer

          # object holding sum, numAnswered, and average for this section (for tooltip right side)
          sectionTotals =
            score: 0
            answered: 0

          # loop through the answerArrays and create [question, average] plot points
          for answersForThisQuestion, i in answerArrays

            # filtering out any N/A answers, realData is the array of answers for a specific question
            realData = answersForThisQuestion.filter (val) -> val isnt defaults.naValue

            _yes = 0
            for d in realData
              _yes++ if d is 1


            # do the math for this question
            score = if realData.length == 0 then 0 else realData.reduce (x,y) -> x + y

            # add every question's average to the array we'll use for tooltip right
            sectionTotals.score += score
            sectionTotals.answered++

          integrityPercent = Math.round(100 * _yes/realData.length)
          # console.log '[ integrityPercent ]', integrityPercent

          baseline = defaults.naValue - 1

          # calculate the overall section average for tooltip display
          integrity = integrityPercent
          difference = 100 - integrityPercent

          # console.log '[ integrity ]', integrity
          # console.log '[ difference ]', difference


          seriesData = {
            data: [
              ['integrity', integrity]
              ['difference', difference]
            ]
          }

          # console.log '[ seriesData ]', seriesData

          # console.log '[ hc ]', hc

          ctrl.dataLoading = false

          # fill chart data with filtered version of parsed data (timeout for forced $apply for highcharts)
          $timeout(=>
            hc = ctrl.config.getChartObj()
            hc.addSeries seriesData, true
          , 0)

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }
