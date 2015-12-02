env = require './env.coffee'
Promise = require 'promise'

MenuCtrl = ($scope) ->
	_.extend $scope,
		env: env
		navigator: navigator

WebServerCtrl = ($scope, model, $location) ->
	_.extend $scope,
		model: model
		save: ->			
			$scope.model.$save().then =>
				$location.url "/webServer"
	
	
WebServerListCtrl = ($scope, collection, $location) ->
	_.extend $scope,
		collection: collection
		create: ->
			$location.url "/webServer/create"					
		edit: (id) ->
			$location.url "/webServer/edit/#{id}"			
		delete: (obj) ->
			obj.$destroy()
		loadMore: ->
			collection.$fetch()
				.then ->
					$scope.$broadcast('scroll.infiniteScrollComplete')
				.catch alert
	
ResLogListCtrl = ($scope, collection, $location, $state) ->
	_.extend $scope,
		collection: collection
		loadMore: ->
			collection.$fetch()
				.then ->
					$scope.$broadcast('scroll.infiniteScrollComplete')
				.catch alert
		doRefresh: ->
			$state.go($state.current, {}, {reload: true});
					

config = ->
	return
	
angular.module('starter.controller', ['ionic', 'ngCordova', 'http-auth-interceptor', 'starter.model', 'platform']).config [config]
angular.module('starter.controller').controller 'MenuCtrl', ['$scope', MenuCtrl]
angular.module('starter.controller').controller 'WebServerCtrl', ['$scope', 'model', '$location', WebServerCtrl]
angular.module('starter.controller').controller 'WebServerListCtrl', ['$scope', 'collection', '$location', WebServerListCtrl]
angular.module('starter.controller').controller 'ResLogListCtrl', ['$scope', 'collection', '$location', '$state', ResLogListCtrl]