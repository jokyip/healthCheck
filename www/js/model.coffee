env = require './env.coffee'
require 'PageableAR'
		
angular.module 'starter.model', ['PageableAR']
	
	.factory 'model', (pageableAR, $filter) ->

		class User extends pageableAR.Model
			$urlRoot: "#{env.authUrl}/org/api/users/"
				
			@me: ->
				(new User(username: 'me/')).$fetch()	
		
		# WebServer model
		class WebServer extends pageableAR.Model
			$urlRoot: "/api/webserver"
			
		class WebServerList extends pageableAR.PageableCollection
			model: WebServer
		
			$urlRoot: "/api/webserver"
			
			$parse: (res, opts) ->
				_.each res.results, (value, key) =>
					res.results[key] = new WebServer res.results[key]
				return res
		
		# ResLog model
		class ResLog extends pageableAR.Model
			$urlRoot: "/api/resLog"
			
		class ResLogList extends pageableAR.PageableCollection
			model: ResLog
			
			$urlRoot: "/api/resLog"
			
			$parse: (res, opts) ->
				_.each res.results, (value, key) =>
					obj = new ResLog res.results[key]
					obj.createdAt = $filter('date') obj.createdAt, 'yyyy-MM-dd HH:mm'
					res.results[key] = obj 
				return res
	
		User:		User
		WebServer:	WebServer
		WebServerList:	WebServerList
		ResLog:	ResLog
		ResLogList:	ResLogList