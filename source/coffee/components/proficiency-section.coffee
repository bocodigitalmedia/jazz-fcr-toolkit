module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'proficiencySection', {
      replace: true
      transclude: true
      templateUrl: 'components/proficiency-section.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        minQuestion: '<'  # number
        maxQuestion: '<'  # number
        height: '<'       # number
        sectionNum: '<'   # number
        # subhead: '<'   # one way bind from parent scope

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Data, Districts, Regions, Users) ->

        # maintain scope across promises and functions
        ctrl = @

        # for chart math
        @H = Highcharts
        @flag = true

        @chartReady = false

        # ---------------------------------------------------------------------------------------------------

        # limiters for chart, 0-based
        @minQuestion = if @minQuestion? then @minQuestion - 1 else 0
        @maxQuestion = if @maxQuestion? then @maxQuestion - 1 else defaults.questions.length
        @height = if @height then @height else 700

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          ctrl.dataLoading = true
          $scope.$on 'dataLoading', => ctrl.dataLoading = true

          $rootScope.$on 'dataReloading', () =>

            # turn self off
            ctrl.dataLoading = true

            # tell the view to hide me
            ctrl.chartReady = false

          # initialize charts
          ctrl.setupChart()
          ctrl.setupCircleChart() if Users.active.group.level is 1

          # when the Data service says it's ready, let this component get to work (with promise error catching)
          # Data.ready.promise.then(@parseUserData).catch (error) -> console.error error
          $scope.$on 'dataReady', => @parseData()

        # ---------------------------------------------------------------------------------------------------

        @setupChart = ->

          # TODO: make 10 not a magic number
          ctrl.pointWidth = 7
          ctrl.groupPadding = 0.2
          ctrl.pointPadding = 0.1

          # set up the chart options
          ctrl.config =
            chart:
              type: 'bar'
              # width: 970
              # height: 900           # dynamic later
              marginLeft: 150
              backgroundColor: 'transparent'
              styledMode: false
              events:
                load: ->
                  ctrl.redrawWithNewHeight this, 10
            title:
              text: null
            subtitle:
              text: null
            xAxis:
              title:
                text: null
            yAxis:
              min: 0
              max: 4
              tickInterval: if ctrl.sectionNum is 5 then 1 else 0.5
              title:
                text: null
              labels:
                overflow: 'justify'
                formatter: ->
                  if ctrl.sectionNum is 5
                    score = this.value
                    totalPossible = defaults.naValue - 1
                    average = score / totalPossible
                    perc = Math.round(100 * average) / 100
                    disp = if isNaN(perc) then 'N/A' else (100*perc) + "%"
                    # perc = average.toFixed 2
                    # disp = if isNaN(perc) then 'N/A' else perc + "%"
                    return disp
                  else
                    return this.value
            tooltip:
              valueSuffix: ' avg'
              # backgroundColor: '#3a85eb'
              # borderRadius: 25
              # borderWidth: 0
              padding: 8
              style:
                color: '#ffffff'
              useHTML: true
              # https://www.highcharts.com/docs/chart-design-and-style/style-by-css
              # https://api.highcharts.com/highcharts/tooltip
              # http://jsfiddle.net/gh/get/jquery/1.7.2/highcharts/highcharts/tree/master/samples/highcharts/css/tooltip-border-background/
              formatter: -> #TODO: SHOW ACTUAL QUESTION
                if ctrl.sectionNum is 5
                  # score = Math.round(10 * this.point.y) / 10 # limit to 1 decimal point so it matches global average
                  score = +(this.point.y.toFixed 2)
                  totalPossible = defaults.naValue - 1
                  average = score / totalPossible
                  perc = Math.round(100 * average) / 100
                  pointPercentage = if isNaN(perc) then 'N/A' else (100*perc) + "%"
                  # perc = average.toFixed 2
                  # pointPercentage = if isNaN(perc) then 'N/A' else perc + "%"

                  score = ctrl.sectionAverages[this.series.name]
                  totalPossible = defaults.naValue - 1
                  average = score / totalPossible
                  perc = Math.round(100 * average) / 100
                  globalAverage = if isNaN(perc) then 'N/A' else (100*perc) + "%"
                  # perc = average.toFixed 2
                  # globalAverage = if isNaN(perc) then 'N/A' else perc + "%"
                else
                  pointPercentage = this.point.y
                  globalAverage = ctrl.sectionAverages[this.series.name]

                '<div class="name">' + this.series.name + '</div>' +
                '<div class="numbers">' +
                '    <div class="left">' +
                '        <div class="number">' + pointPercentage + '</div>' +
                '        <div class="small">' + $rootScope.locale.components.proficiencySection.itemAvg + '</div>' +
                '    </div>' +
                '    <div class="right">' +
                '        <div class="average">' + globalAverage + '</div>' +
                # '        <div class="average">' + 123 + '</div>' +
                '        <div class="small">' + $rootScope.locale.components.proficiencySection.sectionAvg + '</div>' +
                '    </div>' +
                '</div>'
              # positioner: (labelWidth, labelHeight, point) ->
              #   {
              #     x: point.plotX - 20
              #     y: point.plotY - 50
              #   }
            # colors: if Users.superUser then defaults.charts.colors else defaults.charts.colors2                        # setting in each series
            plotOptions:
              area:
                fillColor: '#FF0000'
              bar:
                dataLabels:
                  enabled: false                                    # numbers at the end of each bar
                # pointWidth: ctrl.pointWidth
                # pointPadding: ctrl.pointPadding
                groupPadding: 0.15
              series:
                events:
                  hide: (e) ->
                    ctrl.redrawWithNewHeight e.target.chart, 10
                  show: (e) ->
                    ctrl.redrawWithNewHeight e.target.chart, 10
            legend:
              enabled: true              # floating built-in legend
              align: 'left'
              verticalAlign: 'top'
              squareSymbol: false
              symbolHeight: 0
              symbolWidth: 0
              useHTML: true
              itemDistance: 9
              labelFormatter: ->
                if ctrl.sectionNum is 5
                  score = ctrl.sectionAverages[this.userOptions.name]
                  totalPossible = defaults.naValue - 1
                  average = score / totalPossible
                  perc = Math.round(100 * average) / 100
                  disp = if isNaN(perc) then 'N/A' else (100*perc) + "%"
                  # perc = average.toFixed 2
                  # disp = if isNaN(perc) then 'N/A' else perc + "%"
                else
                  score = ctrl.sectionAverages[this.userOptions.name]
                  disp = if isNaN(score) then 'N/A Avg' else score + ' Avg'
                if Users.active.group.level is 1
                  return '<div id="hc-legend-custom" style="visibility: hidden"></div>'
                else
                  return '<div id="hc-legend-custom"><span class="legend-color" style="background-color: ' + this.color + ';"></span><span class="legend-label">' + this.name + '</span><span class="legend-percentage"> - ' + disp + '</span></div>'
            exporting:
              enabled: true # hamburger menu with save/export options
              buttons:
                contextButton:
                  menuItems: ['downloadPNG', 'downloadJPEG', 'downloadPDF', 'separator', 'printChart']
            credits:
              enabled: false # made by highcharts
            series: []

        # ---------------------------------------------------------------------------------------------------

        @setupCircleChart = ->

          @configCircle =
            chart:
              type: 'pie'
              width: 180
              height: 180
              backgroundColor: 'transparent'
              events:
                addSeries: (event) ->
                  chart = event.target
                  # console.log '%c[ chart ]', 'color: yellow', chart
                  textX = chart.plotLeft + chart.plotWidth * 0.5
                  textY = chart.plotTop + chart.plotHeight * 0.5
                  span = '''
                    <span id="users-proficiency-info-text-''' + ctrl.sectionNum + '''" style="position:absolute; text-align:center;">
                      <span style="font-size: 26px">''' + ctrl.sectionAverages[Users.active.email] + '''</span>
                    </span>'''
                  $('.users-proficiency-percentage-'+ctrl.sectionNum).html span
                  span = $('#users-proficiency-info-text-' + ctrl.sectionNum)
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

        @tallyAnswersForOneDataset = (set, propLookup, propDisplay, color) ->

          # for messaging (and stopping errors) if there's no forms to parse
          noData = !set[ propLookup ]?.completed?

          # stop errors from happening if no completed forms
          return false if noData

          # get this group's forms, which we'll loop through and convert to points
          dataset = set[ propLookup ].completed

          # store answers for each question, eg tally[question 0].answers[form1, form2, form3...]
          answerArrays = []

          # loop through each form in the dataset and store answers to each question, even NAs
          for form in dataset

            formId = form.payload.submissionId

            # first get all the answers to this form
            answers = form.payload.answers

            # then break it down by section (each instance of this component is a subset of questions) using minQuestion and maxQuestion
            slicedAnswers = answers.slice ctrl.minQuestion, ctrl.maxQuestion + 1

            # loop each answer
            for answer, i in slicedAnswers

              # make sure we have an array for this question
              answerArrays[i] ?= []

              # and push it to the answer array
              if ctrl.sectionNum is 5
                switch answer
                  when 1 then answerArrays[i].push 0
                  when 3 then answerArrays[i].push 4
              else
                answerArrays[i].push answer

          # 2-dim array of data points [[timestamp, score]...] (for plotting chart)
          points = []

          # object holding sum, numAnswered, and average for this section (for tooltip right side)
          sectionTotals =
            score: 0
            answered: 0

          # console.log 'answerArrays', answerArrays

          # loop through the answerArrays and create [question, average] plot points
          for answersForThisQuestion, i in answerArrays

            # filtering out any N/A answers, realData is the array of answers for a specific question
            realData = answersForThisQuestion.filter (val) -> val isnt defaults.naValue

            # do the math for this question
            score = if realData.length == 0 then 0 else realData.reduce (x,y) -> x + y
            answered = realData.length
            average = Math.round(100 * score / answered) / 100
            # average = (score / answered).toFixed 2

            # add every question's average to the array we'll use for tooltip right
            sectionTotals.score += score
            sectionTotals.answered += answered

            # console.log '------------------'
            # console.log 'answersForThisQuestion', answersForThisQuestion
            # console.log 'realData', realData
            # console.log 'score', score
            # console.log 'answered', answered
            # console.log 'average', average
            # console.log 'sectionTotals', sectionTotals

            # get x, y values for chart [question, average]
            x = i
            y = average

            # add to the data series array
            points.push [x, y]

          # sort by x coordinate or get highcharts error 15
          points.sort (x, y) -> x[0] - y[0]

          # calculate the overall section average for tooltip display
          # ctrl.sectionAverages[ propDisplay ] = Math.round(10 * sectionTotals.score / sectionTotals.answered) / 10
          ctrl.sectionAverages[ propDisplay ] = +(sectionTotals.score / sectionTotals.answered).toFixed 2

          # create and return the object we'll push to the series for this evaluatee
          seriesObj =
            id: propDisplay
            name: propDisplay
            color: color
            data: points
            marker:
              fillColor: "#ffffff"
              lineColor: null
              lineWidth: 1
              symbol: "circle"

        # ---------------------------------------------------------------------------------------------------

        @parseData = () ->

          switch Users.active.group.level
            when 1 then ctrl.parseUserData()
            when 2 then ctrl.parseManagerData()
            when 3 then ctrl.parseRegionalData()
            when 4 then ctrl.parseNationalData()

        # ---------------------------------------------------------------------------------------------------

        # converts array of forms containing questions into array of questions containing all forms answers
        @parseUserData = ->

          # get the logged in user via lookup so we have extra properties (like districtId)
          user = Users.lookup[ Users.active.id ]

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byEvaluateeByStatus[ user.email ]?.completed?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          # ------------------------------
          # parse the data
          # ------------------------------

          # associative array by user email holding their overall averages
          ctrl.sectionAverages = []

          # add this person's answers to their array
          seriesObj = ctrl.tallyAnswersForOneDataset Data.forms.byEvaluateeByStatus, user.email, user.email, defaults.colors[0]

          # series is an array of objects, but we only have one for level 1 (logged in user)
          ctrl.series = [
            seriesObj
          ]

          # ------------------------------
          # set up the circle chart
          # ------------------------------

          if isNaN ctrl.sectionAverages[user.email]
            proficiency = 0
            difference = defaults.naValue - 1
            ctrl.sectionAverages[user.email] = "N/A"
          else
            baseline = defaults.naValue - 1
            proficiency = ctrl.sectionAverages[user.email]
            difference = baseline - proficiency
          ctrl.seriesCircle =
            data: [
              ['proficiency', proficiency]
              ['difference', difference]
            ]

          # ------------------------------
          # update the page next digest
          # ------------------------------

          # send the data to the chart after a forced apply
          ctrl.updateDisplay true

        # ---------------------------------------------------------------------------------------------------

        # converts array of forms containing questions into array of questions containing all forms answers
        @parseManagerData = (users) ->

          # set up empty array of objects (each person) for the chart
          ctrl.series = []

          # associative array by user email holding their overall averages
          ctrl.sectionAverages = []

          # we only want users in the district; descendants is based on loggedIn not active
          districtId = Districts.lookupByManagerId[ Users.active.id ].id

          # true count of items with data not just overall list
          count = 0

          # for each user in the district/region/nation
          for userId, i in Users.lookupByDistrict[ districtId ]

            # get the user via lookup so we have extra properties (like districtId)
            user = Users.lookup[ userId ]

            # ------------------------------
            # parse the data
            # ------------------------------

            # add this person's answers to their array
            seriesObj = ctrl.tallyAnswersForOneDataset Data.forms.byEvaluateeByStatus, user.email, user.email, defaults.colors[count]

            # series is an array of objects, each item in the array is a user's series
            ctrl.series.push seriesObj if seriesObj

            # only increment count (for colors) if we have real data
            count++ if seriesObj and seriesObj.data.length > 0

          # ------------------------------
          # break if there's no data at all
          # ------------------------------

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = ctrl.series.length is 0

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          # ------------------------------
          # update the page next digest
          # ------------------------------

          # send the data to the chart after a forced apply
          ctrl.updateDisplay()

        # ---------------------------------------------------------------------------------------------------

        # converts array of forms containing questions into array of questions containing all forms answers
        @parseRegionalData = () ->

          # set up empty array of objects (each person) for the chart
          ctrl.series = []

          # associative array by user email holding their overall averages
          ctrl.sectionAverages = []

          # we only want districts in the region; descendants is based on loggedIn not active
          region = Regions.lookupByManagerId[ Users.active.id ]
          districts = region.districts

          # true count of items with data not just overall list
          count = 0

          # for each item in the district/region/nation
          for districtId, i in districts

            # get the district via lookup so we have extra properties (like districtId)
            district = Districts.lookup[ districtId ]

            # ------------------------------
            # parse the data
            # ------------------------------

            # add this person's answers to their array
            seriesObj = ctrl.tallyAnswersForOneDataset Data.forms.byDistrictByStatus, district.id, district.name, defaults.colors[count]

            # series is an array of objects, each item in the array is a user's series
            ctrl.series.push seriesObj if seriesObj

            # only increment count (for colors) if we have real data
            count++ if seriesObj and seriesObj.data.length > 0

          # ------------------------------
          # break if there's no data at all
          # ------------------------------

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = ctrl.series.length is 0

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          # ------------------------------
          # update the page next digest
          # ------------------------------

          # send the data to the chart after a forced apply
          ctrl.updateDisplay()

        # ---------------------------------------------------------------------------------------------------

        # converts array of forms containing questions into array of questions containing all forms answers
        @parseNationalData = () ->

          # set up empty array of objects (each person) for the chart
          ctrl.series = []

          # associative array by user email holding their overall averages
          ctrl.sectionAverages = []

          # we want all regions; descendants is based on loggedIn not active
          regions = []
          regions.push regionId for regionId, region of Regions.all

          # true count of items with data not just overall list
          count = 0

          # for each item in the region/region/nation
          for regionId, i in regions

            # get the region via lookup so we have extra properties (like regionId)
            region = Regions.lookup[ regionId ]

            # ------------------------------
            # parse the data
            # ------------------------------

            # add this person's answers to their array
            seriesObj = ctrl.tallyAnswersForOneDataset Data.forms.byRegionByStatus, region.id, region.name, defaults.colors[count]

            # series is an array of objects, each item in the array is a user's series
            ctrl.series.push seriesObj if seriesObj

            # only increment count (for colors) if we have real data
            count++ if seriesObj and seriesObj.data.length > 0

          # ------------------------------
          # break if there's no data at all
          # ------------------------------

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = ctrl.series.length is 0

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          # ------------------------------
          # update the page next digest
          # ------------------------------

          # send the data to the chart after a forced apply
          ctrl.updateDisplay()

        # ---------------------------------------------------------------------------------------------------

        @redrawWithNewHeight = (chart, barWidth) ->

          # TODO: this math and also chart.series seems to be undefined because of 'this' vs event

          # console.log 'ctrl.H', ctrl.H
          # console.log 'chart.series', chart.series

          debugLocal = false

          #! TIMING ISSUE HERE, SOMETIMES chart.series.length IS 3 AND SOMETIMES 12

          if debugLocal and ctrl.sectionNum is 1
            console.error '------------------------------'
            console.log 'chart.series', chart.series

          numBars = 0
          ctrl.H.each chart.series, (p, i) ->

            if debugLocal and ctrl.sectionNum is 1
              console.log '------------------------------ i', i
              console.log 'p', p
              console.log 'p.visible', p.visible
              console.log 'p.data', p.data

            if p.visible == true
              ctrl.H.each p.data, (ob, j) ->
                if debugLocal and ctrl.sectionNum is 1
                  console.log '---------- j', j
                  console.log 'ob', ob
                  console.log 'numBars', numBars
                numBars++

          numGroups = chart.xAxis[0].categories.length
          numBarsPerGroup = numBars/numGroups

          # height = ctrl.pointWidth * numBars + chart.plotTop + chart.marginBottom
          pxBetweenBars = 2
          pxBetweenGroups = 5

          widthOfBarsAlone = ( barWidth * numBars )
          widthOfBarsSpacing = ( pxBetweenBars * (numBarsPerGroup-1) ) * numGroups
          widthOfGroupsSpacing = ( pxBetweenGroups * numGroups * 2 )
          totalWidth = widthOfBarsAlone + widthOfBarsSpacing + widthOfGroupsSpacing + chart.plotTop + chart.marginBottom

          # HARDCODED
          # height = @height

          if debugLocal and ctrl.sectionNum is 1
            console.error '------------------------------'
            console.log 'chart', chart
            console.log 'chart.series', chart.series
            console.log 'chart.series.length', chart.series.length
            console.log 'barWidth', barWidth
            console.log 'numBars', numBars
            console.log 'numGroups', numGroups
            console.log 'ctrl.pointWidth', ctrl.pointWidth
            console.log 'ctrl.pointPadding', ctrl.pointPadding
            console.log 'ctrl.groupPadding', ctrl.groupPadding
            console.log 'chart.plotTop', chart.plotTop
            console.log 'chart.marginBottom', chart.marginBottom
            console.log 'widthOfBarsAlone', widthOfBarsAlone
            console.log 'widthOfBarsSpacing', widthOfBarsSpacing
            console.log 'widthOfGroupsSpacing', widthOfGroupsSpacing
            console.log 'totalWidth', totalWidth

          if false and ctrl.sectionNum is 5
            console.error '------------------------------'
            console.log 'chart', chart
            console.log 'barWidth', barWidth
            console.log 'numBars', numBars
            console.log 'numGroups', numGroups
            console.log 'ctrl.pointWidth', ctrl.pointWidth
            console.log 'ctrl.pointPadding', ctrl.pointPadding
            console.log 'ctrl.groupPadding', ctrl.groupPadding
            console.log 'chart.plotTop', chart.plotTop
            console.log 'chart.marginBottom', chart.marginBottom
            console.log 'widthOfBarsAlone', widthOfBarsAlone
            console.log 'widthOfBarsSpacing', widthOfBarsSpacing
            console.log 'widthOfGroupsSpacing', widthOfGroupsSpacing
            console.log 'totalWidth', totalWidth

          if totalWidth != chart.chartHeight
            ctrl.flag = true
          if ctrl.flag
            ctrl.flag = false
            chart.setSize null, totalWidth, false
            chart.hasUserSize = null
          return

        # ---------------------------------------------------------------------------------------------------

        @updateDisplay = (circleChart) ->

          # turn self back on
          ctrl.dataLoading = false

          # send the data to the chart after a forced apply
          $timeout =>

            # duh
            numQuestions = ctrl.maxQuestion - ctrl.minQuestion + 1

            # set the labels for the x (left) axis
            ctrl.config.xAxis.categories = defaults.questions.slice(ctrl.minQuestion, ctrl.minQuestion + numQuestions)

            # update the data points
            ctrl.config.series = angular.copy ctrl.series

            # tell the view to turn it on
            ctrl.chartReady = true

            # add the circle chart's series
            ctrl.configCircle.getChartObj().addSeries ctrl.seriesCircle, true if circleChart
          , 0

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }

###

series: [
  {
    name: 'Question 1'
    data: [
      region-1-avg
      region-2-avg
      region-3-avg
      region-4-avg
      region-5-avg
    ]
  }
  {
    name: 'Question 2'
    data: [
      region-1-avg
      region-2-avg
      region-3-avg
      region-4-avg
      region-5-avg
    ]
  }
  {
    name: 'Question 3'
    data: [
      region-1-avg
      region-2-avg
      region-3-avg
      region-4-avg
      region-5-avg
    ]
  }
]

###