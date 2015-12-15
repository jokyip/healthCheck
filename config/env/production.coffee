path = '/healthCheck'

module.exports =
	port: 			8014
	promise:
		timeout:	10000 # ms
	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		scope:				[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/file", "https://mob.myvnc.com/xmpp"]
	webServer:
		access:
			interval: 1 # 1 min		
	models:
		connection: 'mongo'
		migrate:	'alter'
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			host:		'db'
			port:		27017
			user:		'healthCheckrw'
			password:	'pass1234'
			database:	'healthCheck'
	log:
		level:		'silly'
	resLog:
		type:
			error: 		'Error'
			success: 	'Success'
							