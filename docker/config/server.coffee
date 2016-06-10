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
		scope:				[ "https://mob.myvnc.com/org/users"]
	http:
		opts:
			agent:	new agent("http://proxy1.scig.gov.hk:8080")
			follow_max: 5
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
			url:		'mongodb://healthcheck_mongo/healthCheck'
	log:
		level:		'silly'
	resLog:
		type:
			error: 		'Error'
			success: 	'Success'
	im:
		url: 		"https://mob.myvnc.com/im.app/api/msg"
		client:
			id:		'healthCheckMsgAuth'
			secret: 'password'
		user:
			id: 	'healthCheckSails'
			secret: 'password'
		scope:  	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
		txt:		"Health Check message"
		xmpp:
			domain:	'mob.myvnc.com'
		adminjid:	"healthCheckSails@mob.myvnc.com"
		sendmsg:	true		
	
	mail:
		url:	"http://localhost:3002/mail/api/mail"
		subject:	"Health Check message"								