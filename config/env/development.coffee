path = '/healthCheck'
agent = require 'https-proxy-agent'

module.exports =
	path:			path
	url:			"http://localhost:3000"
	port: 			3000
	promise:
		timeout:	10000 # ms
	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		tokenURL:			"https://mob.myvnc.com/org/oauth2/token/"
		scope:				[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/file", "https://mob.myvnc.com/xmpp"]
	http:
		opts:
			agent:	new agent("http://proxy1.scig.gov.hk:8080")
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
			host:		'localhost'
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
	im:
		url: 		"https://mob.myvnc.com/im.app/api/msg"
		client:
			id:		'todomsgDEVAuth'
			secret: 'pass1234'
		user:
			id: 	'todoadmin'
			secret: 'pass1234'
		scope:  	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
		txt:		"Health Check message"
		xmpp:
			domain:	'mob.myvnc.com'
		adminjid:	"todoadmin@mob.myvnc.com"
		sendmsg:	true		
							