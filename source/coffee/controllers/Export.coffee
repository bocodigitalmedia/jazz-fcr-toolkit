daterangepicker = require 'daterangepicker'
$ = require 'jquery'

module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .controller 'ExportController', [
      '$scope'
      '$rootScope'
      '$timeout'
      '$httpParamSerializerJQLike'
      '$http'
      '$mdDialog'
      'locals'
      'Data'
      'Email'
      'Users'
      (
        $scope
        $rootScope
        $timeout
        $httpParamSerializerJQLike
        $http
        $mdDialog
        locals
        Data
        Email
        Users
      ) ->

        $scope.hide =  () ->
          $mdDialog.hide()

        $scope.cancel =  () ->
          $mdDialog.cancel()

        # $scope.exportData = (range) ->
        #   console.log '[ export range ]',  $rootScope.exportRange

        # $scope.wb = {}
        # $scope.completed = false

        # $scope.exportDates = false

        # console.log "export open!"




        # # v For the date filtering v

        # $('#exportFilter').daterangepicker
        #   locale:
        #     cancelLabel: 'Clear'
        #     applyLabel: 'Done'

        # console.log "$('#exportFilter'):", $('#exportFilter')
        # console.log "$('#exportFilter').daterangepicker:", $('#exportFilter').daterangepicker

        # drp = $('#exportFilter').data('daterangepicker')

        # console.log "drp:", drp

        # $('#exportFilter').on 'show.daterangepicker', (ev, picker) ->
        #   $('input').css("visibility", "hidden")

        # $('#exportFilter').on 'hide.daterangepicker', (ev, picker) ->
        #   $('input').css("visibility", "visible")

        # $('#exportFilter').on 'cancel.daterangepicker', (ev, picker) ->
        #   drp.startDate = moment(new Date()).add(-365, 'days')
        #   drp.endDate = moment(new Date())
        #   $rootScope.exportuserdate1 = drp.startDate
        #   $rootScope.exportuserdate2 = drp.endDate
        #   picker.show()

        # $('#exportFilter').data('daterangepicker').setStartDate(moment(new Date()).add(-365, 'days').format("MM/DD/YYYY"))
        # $('#exportFilter').data('daterangepicker').setEndDate(moment(new Date()).format("MM/DD/YYYY"))

        # $rootScope.exportuserdate1 = moment(new Date()).add(-365, 'days').format("MM/DD/YYYY") + "-" + moment(new Date()).format("MM/DD/YYYY")

        # # ^ For the date filtering ^





        # # ---------------------------------------------------------------------------------

        Workbook = ->
          if !(this instanceof Workbook)
            return new Workbook
          @SheetNames = []
          @Sheets = {}
          return

        s2ab = (s) ->
          buf = new ArrayBuffer(s.length)
          view = new Uint8Array(buf)
          i = 0
          while i != s.length
            view[i] = s.charCodeAt(i) & 0xFF
            ++i
          buf

        # ---------------------------------------------------------------------------------

        addWorksheet = (name, data, cols) ->

          ws_name = 'SheetJS'
          ws = XLSX.utils.json_to_sheet(data)
          ws['!cols'] = cols

          $scope.wb.SheetNames.push name
          $scope.wb.Sheets[name] = ws

        # ---------------------------------------------------------------------------------

        gatherReportData = (startDate, endDate) ->

          report = {}
          allForms = []

          for formId, form of Data.forms.allAll
            data = form.payload
            user = Users.lookup[ data.evaluatee.id ]

            # continue if !data.timestamp?

            date1 = moment(startDate)
            item_date = moment(data.timestamp)
            date2 = moment(endDate).add(1, 'days')

            if item_date.isBetween(date1, date2) #and data.status is 'completed'

              # base object
              obj =
                "Status": data.status
                "Accepted Date": if data.timestamp? then moment(data.timestamp).format('MM/DD/YYYY') else 'N/A'
                "Employee": if data.evaluatee.email? then data.evaluatee.email else 'N/A'
                "District Manager": if data.evaluator.email? then data.evaluator.email else 'N/A'
                "District Name": if user?.districtName? then user.districtName else 'N/A'
                "Region Name": if user?.regionName? then user.regionName else 'N/A'

                "Field Ride Start": if data.fieldRideStart? then moment(data.fieldRideStart).format('MM/DD/YYYY') else 'N/A'
                "Field Ride End": if data.fieldRideEnd? then moment(data.fieldRideEnd).format('MM/DD/YYYY') else 'N/A'
                "Total Contact Days": if data.daysInField? then data.daysInField else 'N/A'
                "Type of Activity": if data.activity? then data.activity else 'N/A'

                "Pre-Call Planning": if data.subs.subs1 then "1" else "0"
                "Opening/Establishes Rapport": if data.subs.subs2 then "1" else "0"
                "Effective Questioning": if data.subs.subs3 then "1" else "0"
                "Product Positioning": if data.subs.subs4 then "1" else "0"
                "Handling Objections": if data.subs.subs5 then "1" else "0"
                "Gaining Commitment": if data.subs.subs6 then "1" else "0"
                "Post-Call Analysis": if data.subs.subs7 then "1" else "0"
                "Product / Scientific Knowledge": if data.subsections.subsection2 then "1" else "0"
                "Business Analytics and Planning": if data.subsections.subsection3 then "1" else "0"
                "Team and Leadership Effectiveness": if data.subsections.subsection4 then "1" else "0"
                "Jazz Pharmaceuticals Compliance": if data.answers[0] == 1  then "YES" else "NO"
                "Territory Management/Role Expectations": if data.answers[1] == 1  then "YES" else "NO"

              allForms.push obj

          # TODO: sort by date here
          report.allForms = angular.copy allForms
          report.allForms = report.allForms.sort (a, b) ->
            # console.log a['Accepted Date'], b['Accepted Date'], a['Accepted Date'].valueOf(), b['Accepted Date'].valueOf(), moment(a['Accepted Date']).valueOf(), moment(b['Accepted Date']).valueOf(), moment(a['Accepted Date']).valueOf() < moment(b['Accepted Date']).valueOf() ? -1 : 1
            # return a['Accepted Date'].valueOf() < b['Accepted Date'].valueOf() ? -1 : 1;
            return moment(a['Accepted Date']).valueOf() < moment(b['Accepted Date']).valueOf() ? -1 : 1

          return report

        # ---------------------------------------------------------------------------------

        $scope.exportData = () ->
          console.log "EXPORTING, $rootScope.exportRange", $rootScope.exportRange

          startDate = $rootScope.exportRange.dateStart
          endDate = $rootScope.exportRange.dateEnd

          $scope.exporting = true

          report = gatherReportData(startDate, endDate)

          console.log '%c REPORT: ', 'background-color: red; color: #000', report

          $scope.wb = new Workbook

          date1 = moment(startDate).format('YYYY-MM-DD')
          date2 = moment(endDate).format('YYYY-MM-DD')

          addWorksheet('All FCR Forms', report.allForms, [{wch: 25}, {wch: 15}, {wch: 15}])

          # addWorksheet('RBL Summary', report.evaluatorSummary, [{wch: 25}, {wch: 15}, {wch: 15}])
          # addWorksheet('FCR by RBL', report.formsByEvaluator, [{wch: 25}, {wch: 25}, {wch: 15}, {wch: 15}, {wch: 15}, {wch: 15}, {wch: 15}])
          # addWorksheet('Territory Visits by RBL', report.regionVisitsByEvaluator, [{wch: 25}, {wch: 20}, {wch: 15}, {wch: 15}])

          # path = if window.parent?.cordova?.file? then window.parent.cordova.file.tempDirectory else ''
          path = ''
          switch defaults.brand
            when 'breo' then prefix = 'Breo '
            when 'vaccines' then prefix = 'Vaccines '
            else prefix = ''
          filename = prefix + "FCR Report " + date1 + ' to ' + date2 + '.xlsx'

          # this saves a base64 of the file to a variable so we can attach to email without saving locally
          wbout = XLSX.write $scope.wb, { bookType:'xlsx', bookSST:false, type:'buffer' }

          data =
            file: wbout
            filename: filename
            email: Users.active.email
            name: Users.active.name
            date1: date1
            date2: date2

          console.log 'data', data
          # return false




          ###
            ------------------------------------------------------------------
            this is if we were downloading directly in the browser/portal
            ------------------------------------------------------------------
          ###
          wbout = XLSX.write($scope.wb,
            bookType: 'xlsx'
            bookSST: true
            type: 'binary')

          FileSaver.saveAs new Blob([ s2ab(wbout) ], type: 'application/octet-stream'), path + filename




          ###
            ------------------------------------------------------------------
            this is if we were using cloud functions
            ------------------------------------------------------------------
          ###

          # https://stackoverflow.com/questions/24710503/how-do-i-post-urlencoded-form-data-with-http
          ###
          $http.post('https://us-central1-delphire-lexicon.cloudfunctions.net/emailXLS', $httpParamSerializerJQLike(data), {headers: 'Content-Type': 'application/x-www-form-urlencoded'}).then (resp) ->

            console.log "file posted", resp
          ###





          ###
            ------------------------------------------------------------------
            this is sending using delphire, attaching base64 (TODO)
            ------------------------------------------------------------------
          ###

          ###
          emailData =
            # to: [Users.active.email]
            to: "stephen.mcdonald@bocodigital.com"
            subject: 'Your FCR Report from Delphire'
            data: data
            attach: wbout

          # TODO: this should probably be a promise/response
          Email.send(emailData).then () ->

            console.log "email sent successfully"

            $scope.completed = true
            $timeout ->
              $scope.completed = false
            , 3000

            $scope.exporting = false
          ###

          $scope.hide()

        # # ---------------------------------------------------------------------------------------------------

        # $scope.clearDate = (num) ->
        #   $scope['userdate'+num] = ''

        # ---------------------------------------------------------------------------------
    ]