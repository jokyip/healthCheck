env = require './env.coffee'

window.oalert = window.alert
window.alert = (err) ->
	window.oalert err.data.error
window.Promise = require 'promise'
window._ = require 'lodash'
window.$ = require 'jquery'
window.$.deparam = require 'jquery-deparam'
	
require 'ngCordova'
require 'angular-activerecord'
require 'angular-touch'
require 'tagDirective'
require 'angular-translate'
require 'angular-translate-loader-static-files'
require 'util.auth'
require './app.coffee'
require './controller.coffee'
require './model.coffee'
require './platform.coffee'
require './locale.coffee'