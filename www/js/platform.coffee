env = require './env.coffee'
Promise = require 'promise'

platform = ($rootScope, $cordovaInAppBrowser, $location, $http) ->
	# return promise to authenticate user
	auth = ->
		url = "#{env.oauth2().authUrl}?#{$.param(env.oauth2().opts)}"
		
		func = 
			mobile: ->
				new Promise (fulfill, reject) ->
					document.addEventListener 'deviceready', ->
						$cordovaInAppBrowser.open url, '_blank'
					
					$rootScope.$on '$cordovaInAppBrowser:loadstart', (e, event) ->
						fulfill()
					
					$rootScope.$on '$cordovaInAppBrowser:exit', (e, event) ->
						reject("The sign in flow was canceled")
					
			browser: ->
				new Promise (fulfill, reject) ->
					window.location.href = url
					fulfill()
				
		func[env.platform()]()
		
	# open model.file
	open = (file) ->
		func =
			mobile: ->
				fserr = (err) ->
					msg = []
					msg[FileError.ENCODING_ERR] = 'ENCODING_ERR'
					msg[FileError.INVALID_MODIFICATION_ERR] = 'INVALID_MODIFICATION_ERR'
					msg[FileError.INVALID_STATE_ERR] = 'INVALID_STATE_ERR'
					msg[FileError.NO_MODIFICATION_ALLOWED_ERR] = 'NO_MODIFICATION_ALLOWED_ERR'
					msg[FileError.NOT_FOUND_ERR] = 'NOT_FOUND_ERR'
					msg[FileError.NOT_READABLE_ERR] = 'NOT_READABLE_ERR'
					msg[FileError.PATH_EXISTS_ERR] = 'PATH_EXISTS_ERR'
					msg[FileError.QUOTA_EXCEEDED_ERR] = 'QUOTA_EXCEEDED_ERR'
					msg[FileError.SECURITY_ERR] = 'SECURITY_ERR'
					msg[FileError.TYPE_MISMATCH_ERR] = 'TYPE_MISMATCH_ERR'
					alert msg[err.code]
				transferErr = (err) ->
					msg = []
					msg[FileTransferError.FILE_NOT_FOUND_ERR] = 'FILE_NOT_FOUND_ERR'
					msg[FileTransferError.INVALID_URL_ERR] = 'INVALID_URL_ERR'
					msg[FileTransferError.CONNECTION_ERR] = 'CONNECTION_ERR'
					msg[FileTransferError.ABORT_ERR] = 'ABORT_ERR'
					msg[FileTransferError.NOT_MODIFIED_ERR] = 'NOT_MODIFIED_ERR'
					alert msg[err.code]
				fs = (type, size) ->
					new Promise (fulfill, reject) ->
						window.requestFileSystem type, size, fulfill, reject	
				download = (remote, local, trustAllHosts, opts) ->
					new Promise (fulfill, reject) ->
						fileTransfer = new FileTransfer()
						fileTransfer.download encodeURI(remote), local, fulfill, reject, trustAllHosts, opts 
				open = (local, trustAllCertificates) ->
					new Promise (fulfill, reject) ->
						cordova.plugins.bridge.open local, fulfill, reject, trustAllCertificates
				
				fs(window.PERSISTENT, 0).then (fs) ->
					local = "#{fs.root.toURL()}#{file.path}"
					download(file.url, local, false, headers: $http.defaults.headers.common).then ->
						open(local).catch alert
					.catch transferErr
				.catch fserr
			
			browser: ->
				window.open file.url, '_blank'
				return true
				
		if file.contentType == "text/directory"
			$location.url("file/file?path=#{file.path}")
		else
			func[env.platform()]()
			
	auth: auth
	open: open
	
config =  ($cordovaInAppBrowserProvider) ->
	opts = 
		location: 'no'
		clearsessioncache: 'no'
		clearcache: 'no'
		toolbar: 'no'
		
	document.addEventListener 'deviceready', ->
		$cordovaInAppBrowserProvider.setDefaultOptions(opts)

angular.module('platform', ['ionic', 'ngCordova']).config ['$cordovaInAppBrowserProvider', config]

angular.module('platform').factory 'platform', ['$rootScope', '$cordovaInAppBrowser', '$location', '$http', platform]