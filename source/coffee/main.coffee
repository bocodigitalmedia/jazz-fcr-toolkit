delphireJsNpm = require 'delphire-js-npm'
window.Highcharts = Highcharts = require 'highcharts'
window.Message = require('emailjs').message

require './lib/Blob'
window.FileSaver = FileSaver = require 'file-saver'

window.XLSX = XLSX = require 'xlsx'
require 'angular-js-xlsx'

require 'firebase'
require('highcharts/modules/exporting')(Highcharts)
require 'ui-router-extras'
require 'daterangepicker'
require './lib/md-date-range-picker'

module.exports = (angular, defaults) ->

  dependencies = [
    require 'angular-animate'
    require 'angular-aria'
    require 'angular-material'
    require 'angular-material-data-table'
    require 'angular-moment'
    require 'angular-resource'
    require 'angular-ui-router'
    require 'angularfire'
    require 'highcharts-ng'
    require 'ng-material-datetimepicker'
    'angular-js-xlsx'
    'ct.ui.router.extras'
    'ngMaterialDatePicker'
    'ngMaterialDateRangePicker'
  ]

  angular.module defaults.app.name, dependencies
    .config require './config'
    .run require './run-once'
    .constant 'constants',
      NUM_CHOICES: 2
      NUM_QUESTIONS: 2

    .filter 'trust', [
      '$sce'
      ($sce) ->
        (htmlCode) ->
          # console.log 'htmlCode', htmlCode
          $sce.trustAsHtml htmlCode
    ]

    .filter 'htmlToText', ->
      (text) ->
        if text then String(text).replace(/<[^>]+>/gm, '') else ''

    .filter 'tsFormat', ->
      (ts) ->
        return if !ts
        return '-' if ts is '-'
        try
          return moment(ts).format('M/D/YY')
        catch err
          return '-'

    .filter 'shorten',  ->
      (email) ->
        return if !email
        return email.match(/^[^@]+/g)[0]

    .filter 'range', ->
      (n) ->
        res = []
        i = 0
        while i < n
          res.push i
          i++
        res

    .filter 'dateRange', ->
      (items, fromDate, toDate) ->

        if !toDate
          return items
        else
          # console.log '%c[ dateRangeFILTER ]', 'color: deeppink', fromDate, toDate
          # console.log '[ items ]', items

          filtered = []
          from_date = moment(fromDate).set({hour: 0, minute: 0, second: 0})
          to_date = moment(toDate).set({hour: 23, minute: 59, second: 59})
          # console.log '[ from_date]', from_date
          # console.log '[ to_date ]', to_date

          angular.forEach items, (item) ->
            return if !item.payload?.timestamp?

            # console.log '%c[ item ]', 'color: aqua', item
            # console.log '%c[ timestamp ]', 'color: deeppink', item.payload.timestamp

            item_date = moment(item.payload.timestamp)
            if item_date.isBetween(from_date, to_date)
              filtered.push item
            return
          filtered

    .filter 'dateTimeRange', ->
      (items, fromDate, toDate) ->
        filtered = []
        from_date = new Date(fromDate).getTime()
        to_date = new Date(toDate).getTime()
        angular.forEach items, (item) ->
          item_date = new Date(item.date).getTime()
          if item_date >= from_date and item_date <= to_date
            filtered.push item
          return
        filtered

    .filter 'filterUserType', ($rootScope, Data, Users) ->
      (items, regionPath, type) ->
        filtered = []
        return items if Users.superUser and not Users.viewAsRbl
        # console.log "____________________________________"
        angular.forEach items, (item) ->
          # console.log "item", item
          region = item[regionPath]
          # console.log "region", region
          # console.log "type", type
          regionId = if type? and type is 'name' then Data.regions.nameLookup[region] else region
          # console.log Users.active.regionId, regionId
          if regionId is Users.active.regionId
            filtered.push item
          return
        # console.log "items", items
        # console.log "filtered", filtered
        filtered