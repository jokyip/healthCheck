http = require 'needle'
fs = require 'fs'
Promise = require 'promise'

dir = '/etc/ssl/certs'
files = fs.readdirSync(dir).filter (file) -> /.*\.pem/i.test(file)
files = files.map (file) -> "#{dir}/#{file}"
ca = files.map (file) -> fs.readFileSync file

options = 
	timeout:	sails.config.promise.timeout
	ca:			ca	
		
module.exports =
	get: (token, url) ->
		new Promise (fulfill, reject) ->
			opts = _.extend options, sails.config.http.opts,
				headers:
					Authorization:	"Bearer #{token}"

			http.get url, opts, (err, res) ->
				if err
					return reject err
				fulfill res
				
	post: (token, url, data) ->
		new Promise (fulfill, reject) ->
			opts = _.extend options, sails.config.http.opts,
				headers:
					Authorization:	"Bearer #{token}"
			http.post url, data, opts, (err, res) ->
				if err
					return reject err
				fulfill res
				
	# get token for Resource Owner Password Credentials Grant
	# url: 	authorization server url to get token 
	# client:
	#	id: 	registered client id
	#	secret:	client secret
	# user:
	#	id:		registered user id
	#	secret:	user password
	# scope:	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
	token: (url, client, user, scope) ->
		opts = _.extend options,
			headers =
				'Content-Type':	'application/x-www-form-urlencoded'
				username:		client.id
				password:		client.secret
		data =
			grant_type: 	'password'
			username:		user.id
			password:		user.secret 
			scope:			scope.join(' ')
		new Promise (fulfill, reject) ->
			http.post url, data, opts, (err, res) ->
				if err
					return reject err
				fulfill res