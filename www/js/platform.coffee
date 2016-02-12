env = require './env.coffee'
Promise = require 'promise'

platform = ($rootScope, $cordovaInAppBrowser, $location, $http, $ionicModal, authService) ->
	# return promise to authenticate user
	auth = ->
		url = "#{env.oauth2().authUrl}?#{$.param(env.oauth2().opts)}"
		
		func = 
			mobile: ->
				p = new Promise (fulfill, reject) ->
					document.addEventListener 'deviceready', ->
						$cordovaInAppBrowser.open url, '_blank'
					
					$rootScope.$on '$cordovaInAppBrowser:loadstart', (e, event) ->
						authService.matchUrl event.url, fulfill, reject
					
					$rootScope.$on '$cordovaInAppBrowser:exit', (e, event) ->
						reject("The sign in flow was canceled")

				p
					.then (data) ->
						$cordovaInAppBrowser.close()
						authService.loginConfirmed data
					.catch (err) ->
						$cordovaInAppBrowser.close()
						authService.loginCancelled null, err.error
				
			browser: ->
				templateStr = """
					<ion-modal-view>
						<ion-content>
							<iframe src='#{url}'></iframe>
						</ion-content>
					</ion-modal-view>
				"""
				$rootScope.modal = $ionicModal.fromTemplate(templateStr)
				$rootScope.modal.show()
				
		func[env.platform()]()
			
	auth: auth
	
config =  ($cordovaInAppBrowserProvider) ->
	opts = 
		location: 'no'
		clearsessioncache: 'no'
		clearcache: 'no'
		toolbar: 'no'
		
	document.addEventListener 'deviceready', ->
		$cordovaInAppBrowserProvider.setDefaultOptions(opts)
		cordova?.plugins.Keyboard.hideKeyboardAccessoryBar(true)
		cordova?.plugins.autoStart.enable()

angular.module('platform', ['ionic', 'ngCordova', 'starter.controller'])

	.config ['$cordovaInAppBrowserProvider', config]

	.factory 'platform', ['$rootScope', '$cordovaInAppBrowser', '$location', '$http', '$ionicModal', 'authService', platform]