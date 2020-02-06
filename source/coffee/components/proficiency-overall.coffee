module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .component 'proficiencyOverall', {
      replace: true
      transclude: true
      templateUrl: 'components/proficiency-overall.html'
      controllerAs: 'ctrl'
      bindings:
        title: '@'     # string component
        # subhead: '<'   # one way bind from parent scope

      # =========================================================================================================

      controller: ($rootScope, $scope, $timeout, Data, Districts, Regions, Users, Forms) ->

        # to maintain scope across promises and functions
        ctrl = @

        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        H = Highcharts
        H.wrap H.Tooltip.prototype, 'refresh', (p, point, mouseEvents) ->
          p.call this, point, mouseEvents
          label = @label
          if point and label
            label.attr fill: point.series.color
          return

        @config =
          chart:
            type: 'spline'
            backgroundColor: 'transparent'
            # width: 970
            zoomType: 'x'
          title:
            text: null
          subtitle:
            text: null
          xAxis:
            type: 'datetime'
            minTickInterval: moment.duration(0.25, 'day').asMilliseconds()
            startOnTick: true
            endOnTick: true
            # tickInterval: 24 * 3600 * 1000
            dateTimeLabelFormats:
              second: '%b %e<br>%I:%M %P '
              minute: '%b %e<br>%I:%M %P'
              hour: '%b %e<br>%I:%M %P'
              day: '%b %e<br>%I:%M %P' #* http://php.net/manual/en/function.strftime.php
              week: '%e %b'
              month: '%y/%m/%d'
              year: '%y/%m'
            title:
              text: null
          yAxis:
            min: 0
            max: 4
            # tickInterval: 0.5
            title:
              text: null
            min: 0
          tooltip:
            # headerFormat: '<b>{series.name}</b><br>'
            # pointFormat: '{point.x}, {point.y}'
            backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF')
            borderRadius: 10
            borderWidth: 0
            padding: 8
            style:
              color: '#ffffff'
            useHTML: true
            formatter: (e) ->

              switch Users.active.group.level
                when 1 then avg = ctrl.userAverage
                when 2 then avg = ctrl.userAverages[ this.series.name ]
                when 3 then avg = ctrl.userAverages[ this.series.name ]
                when 4 then avg = ctrl.userAverages[ this.series.name ]

              switch Users.active.group.level
                when 1 then extra = ''
                when 2 then extra = ''
                when 3 then extra = '<div class="subname">' + this.point.name + '</div>'
                when 4 then extra = '<div class="subname">' + this.point.name + '</div>'

              '<div class="name">' + this.series.name + '</div>' +
              extra +
              '<div class="numbers">' +
              '    <div class="left">' +
              '        <div class="number">' + this.point.y + '</div>' +
              '        <div class="small">' + moment(this.point.x).format('YYYY MMM, D') + '</div>' +
              '    </div>' +
              '    <div class="right">' +
              '        <div class="average">' + avg + '</div>' +
              # '        <div class="average">' + 123 + '</div>' +
              '        <div class="small">' + $rootScope.locale.components.glance.overallAvg + '</div>' +
              '    </div>' +
              '</div>'
          plotOptions:
            spline:
              marker:
                enabled: true
          legend:
            enabled: ( Users.active.group.level > 1 )             # floating built-in legend
            align: 'left'
            verticalAlign: 'top'
            squareSymbol: false
            symbolHeight: 0
            symbolWidth: 0
            useHTML: true
            itemDistance: 10
            labelFormatter: ->
              if ctrl.sectionNum is 5
                score = ctrl.userAverages[this.userOptions.name]
                totalPossible = defaults.naValue - 1
                average = score / totalPossible
                # perc = Math.round(100 * average) / 100
                # disp = if isNaN(perc) then 'N/A' else (100*perc) + "%"
                perc = average.toFixed 2
                disp = if isNaN(perc) then 'N/A' else perc + "%"
              else
                score = ctrl.userAverages[this.userOptions.name]
                disp = if isNaN(score) then 'N/A Avg' else score + ' Avg'
              return '<div id="hc-legend-custom"><span class="legend-color" style="background-color: ' + this.color + ';"></span><span class="legend-label">' + this.name + '</span><span class="legend-percentage"> - ' + disp + '</span></div>'
          exporting:
            enabled: true # hamburger menu with save/export options
            buttons:
              contextButton:
                menuItems: ['downloadPNG', 'downloadJPEG', 'downloadPDF', 'separator', 'printChart']
          credits:
            enabled: false            # made by highcharts
          series: []

        if defaults.language is 'fr'
          H.setOptions(
            lang:
              loading: 'Chargement...',
              months: ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre']
              shortMonths: ['JAN', 'FÉV', 'MAR', 'AVR', 'MAI', 'JUN', 'JUL', 'AOÛ', 'SEP', 'OCT', 'NOV', 'DÉC']
        )

        # ---------------------------------------------------------------------------------------------------

        @$onInit = ->

          ctrl.dataLoading = true
          $scope.$on 'dataLoading', => ctrl.dataLoading = true

          # when the Data service says it's ready, let this component get to work (with promise error catching)
          $scope.$on 'dataReady', =>
            switch Users.active.group.level
              when 1 then @parseUserData()
              when 2 then @parseManagerData()
              when 3 then @parseRegionalData()
              when 4 then @parseNationalData()

        # ---------------------------------------------------------------------------------------------------

        @parseUserData = () ->

          # console.log '[ parse rep data ]'

          # get the logged in user via lookup so we have extra properties (like districtId)
          user = Users.lookup[ Users.active.id ]

          # for messaging (and stopping errors) if there's no forms to parse
          ctrl.noData = !Data.forms.byEvaluateeByStatus[ Users.active.email ]?.completed?

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          # get this user's forms, which we'll loop through and convert to points
          dataset = Data.forms.byEvaluateeByStatus[ Users.active.email ].completed

          # 2-dim array of data points [[timestamp, score]...]
          points = []

          # used to calculate user average
          totals =
            score: 0
            answered: 0

          # loop through each form in the dataset and convert timestamp/average to x/y, COMPLETED forms only
          for form in dataset

            formId = form.payload.submissionId

            # filter out any N/A answers then get sum of and number of non-NA answers (and tally across all forms)
            realData = form.payload.answers.filter (val) -> val isnt defaults.naValue
            totals.score += realData.reduce (x,y) -> x + y
            totals.answered += realData.length

            # get the [x,y] for this form as [timestamp, average]
            x = new Date(form.payload.timestamp).getTime()
            y = form.payload.average

            # add to the data series array
            points.push [x, y]

          # sort by x coordinate or get highcharts error 15
          points.sort (x, y) -> x[0] - y[0]

          # calculate overall user average for tooltip display
          # ctrl.userAverage = Math.round(100 * totals.score / totals.answered) / 100
          ctrl.userAverage = (totals.score / totals.answered).toFixed 2

          # create the object we'll push to the series for this evaluatee
          ctrl.preparedSeriesData = [
            id: Users.active.id
            name: Users.active.email
            color: defaults.colors[0]
            data: points
            marker:
              fillColor: "#ffffff"
              lineColor: null
              lineWidth: 1
              symbol: "circle"
          ]

          ctrl.updateChart()

        # ---------------------------------------------------------------------------------------------------

        @parseManagerData = () ->

          # get the logged in user via lookup so we have extra properties (like districtId)
          # user = Users.lookup[ Users.active.id ]

          # loop all subordinates and make sure at least someone has a completed form somewhere
          hasData = false
          for subordinate in Users.subordinates
            if Data.forms.byEvaluateeByStatus[ subordinate.email ]?.completed?
              hasData = true
              break
          ctrl.noData = !hasData

          # stop errors from happening if no completed forms
          return false if ctrl.noData

          # 'array' of averages by userid for displaying in tooltip
          ctrl.userAverages = {}

          # data for the chart, array of objects where each object is one user's line
          ctrl.data = []

          # true count of items with data not just overall list
          count = 0

          # loop through my subordinates and tally their data
          for subordinate, index in Users.subordinates

            # if we don't have data for this user, don't show them
            continue if !Data.forms.byEvaluateeByStatus[ subordinate.email ]?.completed?

            # get this user's forms, which we'll loop through and convert to points
            dataset = Data.forms.byEvaluateeByStatus[ subordinate.email ].completed

            # 2-dim array of data points [[timestamp, score]...]
            points = []

            # used to calculate user average
            totals =
              score: 0
              answered: 0

            # loop through each form in the dataset and convert timestamp/average to x/y, COMPLETED forms only
            for form in dataset

              formId = form.payload.submissionId

              # filter out any N/A answers then get sum of and number of non-NA answers (and tally across all forms)
              realData = form.payload.answers.filter (val) -> val isnt defaults.naValue
              totals.score += realData.reduce (x,y) -> x + y
              totals.answered += realData.length

              # get the [x,y] for this form as [timestamp, average]
              x = new Date(form.payload.timestamp).getTime()
              y = form.payload.average

              # add to the data series array
              points.push [x, y]

            # sort by x coordinate or get highcharts error 15
            points.sort (x, y) -> x[0] - y[0]

            # calculate overall user average for tooltip display
            # userAverage = Math.round(100 * totals.score / totals.answered) / 100
            userAverage = (totals.score / totals.answered).toFixed 2

            # push it to the array for tooltip
            ctrl.userAverages[ subordinate.email ] = userAverage

            # get subordinate details (for district id)
            user = Users.lookup[ subordinate.id ]

            # create the object we'll push to the series for this evaluatee
            preparedSeriesData =
              id: user.id
              name: user.email
              color: defaults.colors[count]
              # color: defaults.activeDistricts[ user.districtId ].color
              data: points
              marker:
                fillColor: "#ffffff"
                lineColor: null
                lineWidth: 1
                symbol: "circle"

            # only increment count (for colors) if we have real data
            count++ if points.length > 0

            # push the user's data to the line chart series
            ctrl.data.push preparedSeriesData

          ctrl.preparedSeriesData = angular.copy ctrl.data

          ctrl.updateChart()

        # ---------------------------------------------------------------------------------------------------

        @parseRegionalData = () ->

          # get the logged in user via lookup so we have extra properties (like districtId)
          # user = Users.lookup[ Users.active.id ]

          # loop all subordinates and make sure at least someone has a completed form somewhere
          # hasData = false
          # for subordinate in Users.subordinates
          #   if Data.forms.byEvaluateeByStatus[ subordinate.email ]?.completed?
          #     hasData = true
          #     break
          # ctrl.noData = !hasData

          # stop errors from happening if no completed forms
          # return false if ctrl.noData

          # 'array' of averages by userid for displaying in tooltip
          ctrl.userAverages = {}

          # data for the chart, array of objects where each object is one user's line
          ctrl.data = []

          # we only want districts in the region; descendants is based on loggedIn not active
          region = Regions.lookupByManagerId[ Users.active.id ]
          districts = region.districts

          # make sure when we're done looping there's some kind of data somewhere
          hasData = false

          # true count of items with data not just overall list
          count = 0

          # loop through my subordinates and tally their data
          for districtId, index in districts

            # if we don't have data for this user, don't show them
            continue if !Data.forms.byDistrictByStatus[ districtId ]?.completed?

            # if we find one form then we have data
            hasData = true

            # get this user's forms, which we'll loop through and convert to points
            dataset = Data.forms.byDistrictByStatus[ districtId ].completed

            # get detailed district info
            district = Districts.lookup[ districtId ]

            # 2-dim array of data points [[timestamp, score]...]
            points = []

            # used to calculate user average
            totals =
              score: 0
              answered: 0

            # loop through each form in the dataset and convert timestamp/average to x/y, COMPLETED forms only
            for form in dataset

              formId = form.payload.submissionId

              # filter out any N/A answers then get sum of and number of non-NA answers (and tally across all forms)
              realData = form.payload.answers.filter (val) -> val isnt defaults.naValue
              totals.score += realData.reduce (x,y) -> x + y
              totals.answered += realData.length

              # get the [x,y] for this form as [timestamp, average]
              x = new Date(form.payload.timestamp).getTime()
              y = form.payload.average

              # add to the data series array
              # points.push [x, y]
              points.push
                x: x
                y: y
                name: form.payload.evaluatee.email

            # sort by x coordinate or get highcharts error 15
            # points.sort (x, y) -> x[0] - y[0]
            points.sort (a,b) => return a.x - b.x

            # calculate overall user average for tooltip display
            # userAverage = Math.round(100 * totals.score / totals.answered) / 100
            userAverage = (totals.score / totals.answered).toFixed 2

            # push it to the array for tooltip
            ctrl.userAverages[ district.name ] = userAverage

            # create the object we'll push to the series for this evaluatee
            preparedSeriesData =
              id: district.name
              name: district.name
              color: defaults.colors[count]
              # color: defaults.activeDistricts[ user.districtId ].color
              data: points
              marker:
                fillColor: "#ffffff"
                lineColor: null
                lineWidth: 1
                symbol: "circle"

            # only increment count (for colors) if we have real data
            count++ if points.length > 0

            # push the user's data to the line chart series
            ctrl.data.push preparedSeriesData

          ctrl.preparedSeriesData = angular.copy ctrl.data

          ctrl.noData = !hasData

          ctrl.updateChart()

        # ---------------------------------------------------------------------------------------------------

        @parseNationalData = () ->

          # 'array' of averages by userid for displaying in tooltip
          ctrl.userAverages = {}

          # data for the chart, array of objects where each object is one user's line
          ctrl.data = []

          # we want all regions; descendants is based on loggedIn not active
          regions = []
          regions.push regionId for regionId, region of Regions.all

          # make sure when we're done looping there's some kind of data somewhere
          hasData = false

          # true count of items with data not just overall list
          count = 0

          # for each item in the region/region/nation
          for regionId, index in regions

            # if we don't have data for this user, don't show them
            continue if !Data.forms.byRegionByStatus[ regionId ]?.completed?

            # if we find one form then we have data
            hasData = true

            # get this user's forms, which we'll loop through and convert to points
            dataset = Data.forms.byRegionByStatus[ regionId ].completed

            # get detailed district info
            region = Regions.lookup[ regionId ]

            # 2-dim array of data points [[timestamp, score]...]
            points = []

            # used to calculate user average
            totals =
              score: 0
              answered: 0

            # loop through each form in the dataset and convert timestamp/average to x/y, COMPLETED forms only
            for form in dataset

              formId = form.payload.submissionId

              #! LOOP AND STRIP FALSE includedQuestions
              validAnswers = []
              i = 0
              for answer in form.payload.answers
                if defaults.includedQuestions[i]
                  validAnswers.push answer
                i++

              # filter out any N/A answers then get sum of and number of non-NA answers (and tally across all forms)
              realData = validAnswers.filter (val) -> val isnt defaults.naValue

              # break out if they answered all NA
              continue if realData.length == 0

              totals.score += realData.reduce (x,y) -> x + y
              totals.answered += realData.length

              # get the [x,y] for this form as [timestamp, average]
              x = new Date(form.payload.timestamp).getTime()
              y = form.payload.average

              # add to the data series array
              # points.push [x, y]
              points.push
                x: x
                y: y
                name: form.payload.evaluatee.email

            # sort by x coordinate or get highcharts error 15
            # points.sort (x, y) -> x[0] - y[0]
            points.sort (a,b) => return a.x - b.x

            # calculate overall user average for tooltip display
            # userAverage = Math.round(100 * totals.score / totals.answered) / 100
            userAverage = (totals.score / totals.answered).toFixed 2

            # push it to the array for tooltip
            ctrl.userAverages[ region.name ] = userAverage

            # create the object we'll push to the series for this evaluatee
            preparedSeriesData =
              id: region.name
              name: region.name
              color: defaults.colors[count]
              # color: defaults.activeDistricts[ user.districtId ].color
              data: points
              marker:
                fillColor: "#ffffff"
                lineColor: null
                lineWidth: 1
                symbol: "circle"

            # only increment count (for colors) if we have real data
            count++ if points.length > 0

            # push the user's data to the line chart series
            ctrl.data.push preparedSeriesData

          ctrl.preparedSeriesData = angular.copy ctrl.data

          ctrl.noData = !hasData

          ctrl.updateChart()

          # console.log '%c[ representative: parse National Data ]', 'color: lime'

        # ---------------------------------------------------------------------------------------------------

        @updateChart = ->

          # local copy of data so we don't destroy it
          preparedSeriesData = angular.copy ctrl.preparedSeriesData

          # fill chart data with filtered version of parsed data (based on selectize, timeout for forced $apply for highcharts)
          $timeout(->
            ctrl.config.series = preparedSeriesData
            ctrl.dataLoading = false
          , 0)

        # ---------------------------------------------------------------------------------------------------

        return true

      # =========================================================================================================
    }