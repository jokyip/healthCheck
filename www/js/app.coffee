module = angular.module('starter', ['ionic', 'starter.controller', 'http-auth-interceptor', 'ngTagEditor', 'ActiveRecord', 'angularFileUpload', 'ngTouch', 'ionic-datepicker', 'ngFancySelect', 'ionic-press-again-to-exit', 'pascalprecht.translate', 'locale'])

module.run ($rootScope, platform, $ionicPlatform, $location, $http, authService, $cordovaToast, $ionicPressAgainToExit) ->
	$ionicPlatform.ready ->
		if (window.cordova && window.cordova.plugins.Keyboard)
			cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
		if (window.StatusBar)
			StatusBar.styleDefault()
			
	$ionicPressAgainToExit ->
		$cordovaToast.show 'Press again to exit', 'short', 'center'
		
	# set authorization header once browser authentication completed
	if $location.url().match /access_token/
			data = $.deparam $location.url().split("/")[1]
			$http.defaults.headers.common.Authorization = "Bearer #{data.access_token}"
			authService.loginConfirmed()
			
	# set authorization header once mobile authentication completed
	fulfill = (data) ->
		if data?
			$http.defaults.headers.common.Authorization = "Bearer #{data.access_token}"
			authService.loginConfirmed()
	
	$rootScope.$on 'event:auth-forbidden', ->
		platform.auth().then fulfill, alert
	$rootScope.$on 'event:auth-loginRequired', ->
		platform.auth().then fulfill, alert
		
module.config ($stateProvider, $urlRouterProvider) ->
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
		
	$urlRouterProvider.otherwise('/webServer')