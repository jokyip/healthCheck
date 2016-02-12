env = require './env.coffee'

angular.module 'starter', ['ionic', 'starter.controller', 'starter.model', 'util.auth', 'ActiveRecord', 'ngTouch', 'ionic-datepicker', 'ngFancySelect', 'pascalprecht.translate', 'locale']

	.run (authService) ->
		authService.login env.oauth2.opts
		
	.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
		$ionicPlatform.ready ->
			if (window.cordova && window.cordova.plugins.Keyboard)
				cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
			if (window.StatusBar)
				StatusBar.styleDefault()
						
	.config ($stateProvider, $urlRouterProvider) ->
		$stateProvider.state 'app',
			url: ""
			abstract: true
			templateUrl: "templates/menu.html"
	
		# WebServer
		$stateProvider.state 'app.webServer',
			url: "/webServer"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/webServer/list.html"
					controller: 'WebServerListCtrl'
			resolve:
				cliModel: 'model'	
				collection: (cliModel) ->
					ret = new cliModel.WebServerList()
					ret.$fetch()		
					
		$stateProvider.state 'app.webServerCreate',
			url: "/webServer/create"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/webServer/create.html"
					controller: 'WebServerCtrl'
			resolve:
				cliModel: 'model'	
				model: (cliModel) ->
					ret = new cliModel.WebServer()
					
		$stateProvider.state 'app.webServerEdit',
			url: "/webServer/edit/:id"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/webServer/edit.html"
					controller: 'WebServerCtrl'
			resolve:
				id: ($stateParams) ->
					$stateParams.id
				cliModel: 'model'	
				model: (cliModel, id) ->
					ret = new cliModel.WebServer({id: id})
					ret.$fetch()			
	
		# ResLog
		$stateProvider.state 'app.resLog',
			url: "/resLog"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/resLog/list.html"
					controller: 'ResLogListCtrl'
			resolve:
				cliModel: 'model'	
				collection: (cliModel) ->
					ret = new cliModel.ResLogList()
					ret.$fetch()
			
		$urlRouterProvider.otherwise('/resLog')