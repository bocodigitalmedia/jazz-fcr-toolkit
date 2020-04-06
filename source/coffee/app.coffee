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

window.defaults = defaults = require './defaults-SLEEP-PRODUCTION'
window.locale = locale = require '../../public/locale/en-jazz.json'
# defaults.testUserSleep = "boco-super-emmons"
# defaults.testUserSleep = "boco-super-mcdonald"
# defaults.testUserSleep = "boco-super-gabe"
# defaults.testUserSleep = "national-director"
# defaults.testUserSleep = "regional-manager-south"
# defaults.testUserSleep = "manager-southeast"
# defaults.testUserSleep = "rep-southeast-3"
# defaults.testUserSleep = "national-director"

# valid users
# "rep-southeast-1"
# "rep-southeast-2"
# "rep-southeast-3"
# "manager-southeast"
# "regional-manager-south"
# "national-director"
# "boco-super-emmons"
# "boco-super-mcdonald"
# "boco-super-gabe"

#? --------------------------------------------
#? HEMONC PRODUCTION                          -
#? --------------------------------------------

# window.defaults = defaults = require './defaults-HEMONC-PRODUCTION'
# window.locale = locale = require '../../public/locale/en-jazz.json'
# defaults.testUserHemonc = "boco-super-emmons"
# defaults.testUserHemonc = "boco-super-mcdonald"
# defaults.testUserHemonc = "rep-southwest-1"
# defaults.testUserHemonc = "national-director"

# valid users
# "rep-southwest-1"
# "rep-southwest-2"
# "rep-southwest-3"
# "manager-southwest"
# "national-director"
# "boco-super-emmons"
# "boco-super-mcdonald"
# "boco-super-gabe"


#! ---------------------------------------------------------------------------------------------------------------

#? --------------------------------------------
#? LOAD                                       -
#? --------------------------------------------

require('./load-modules')(angular, defaults)
