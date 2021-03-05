loadscript = require './lib/loadscript'

window.firebase = firebase = require 'firebase'
window.$ = window.jQuery = require 'jquery'
window.Delphire = delphireJsNpm = require 'delphire-js-npm'
window.moment = require 'moment'

angular = require 'angular'

#! ---------------------------------------------------------------------------------------------------------------

#? --------------------------------------------
#? BOCO TEST PRODUCTION                     -
#? --------------------------------------------

window.defaults = defaults = require './defaults-DEV'
window.locale = locale = require '../../public/locale/en-jazz.json'

#~ HEMONC
defaults.testUserHemonc = "boco-super-emmons"
# defaults.testUserHemonc = "rep1-district1"
# defaults.testUserHemonc = "rep2-district1"
# defaults.testUserHemonc = "rep3-district1"
# defaults.testUserHemonc = "rep1-district2"
# defaults.testUserHemonc = "rep2-district2"
# defaults.testUserHemonc = "rep3-district2"
# defaults.testUserHemonc = "manager1-district1" # PHILADELPHIA
# defaults.testUserHemonc = "manager2-district2" # SAN DIEGO
# defaults.testUserHemonc = "regional-manager-1" # EAST
# defaults.testUserHemonc = "regional-manager-2" # WEST
# defaults.testUserHemonc = "national-director"
# defaults.testUserHemonc = "roddy-mcilwain"

#~ SLEEP
# defaults.testUserSleep = "boco-super-emmons"
# defaults.testUserSleep = "rep1-district1"
# defaults.testUserSleep = "rep2-district1"
# defaults.testUserSleep = "rep3-district1"
# defaults.testUserSleep = "rep1-district2"
# defaults.testUserSleep = "rep2-district2"
# defaults.testUserSleep = "rep3-district2"
# defaults.testUserSleep = "manager1-district1" # PHILADELPHIA
# defaults.testUserSleep = "manager2-district2" # SAN DIEGO
# defaults.testUserSleep = "regional-manager-1" # EAST
# defaults.testUserSleep = "regional-manager-2" # WEST
# defaults.testUserSleep = "national-director"

#? --------------------------------------------
#? SLEEP PRODUCTION                           -
#? --------------------------------------------

# window.defaults = defaults = require './defaults-SLEEP-PRODUCTION'
# window.locale = locale = require '../../public/locale/en-jazz.json'
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
# defaults.testUserHemonc = "roddy-mcilwain"
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
