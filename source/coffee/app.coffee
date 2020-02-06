loadscript = require './lib/loadscript'

window.firebase = firebase = require 'firebase'
window.$ = window.jQuery = require 'jquery'
window.Delphire = delphireJsNpm = require 'delphire-js-npm'
window.moment = require 'moment'

angular = require 'angular'

#! ---------------------------------------------------------------------------------------------------------------

#? --------------------------------------------
#? SLEEP PRODUCTION                           -
#? --------------------------------------------

# window.defaults = defaults = require './defaults-SLEEP-PRODUCTION'
# window.locale = locale = require '../../public/locale/en-jazz.json'
# defaults.testUserSleep = "boco-super-mcdonald"
# defaults.testUserSleep = "boco-super-emmons"

# valid users
# "rep-southeast-1"
# "rep-southeast-2"
# "rep-southeast-3"
# "manager-southeast"
# "regional-manager-south"
# "national-director"
# "boco-super-emmons"
# "boco-super-mcdonald"

#? --------------------------------------------
#? HEMONC PRODUCTION                          -
#? --------------------------------------------

window.defaults = defaults = require './defaults-HEMONC-PRODUCTION'
window.locale = locale = require '../../public/locale/en-jazz.json'
# defaults.testUserHemonc = "boco-super-mcdonald"
# defaults.testUserHemonc = "boco-super-emmons"

# valid users
# "rep-southwest-1"
# "rep-southwest-2"
# "rep-southwest-3"
# "manager-southwest"
# "national-director"
# "boco-super-emmons"
# "boco-super-mcdonald"

#! ---------------------------------------------------------------------------------------------------------------

#? --------------------------------------------
#? LOAD                                       -
#? --------------------------------------------

require('./load-modules')(angular, defaults)
