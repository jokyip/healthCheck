Sails = require 'sails'

sails = null

before (done) ->
	
	Sails.lift {
		hooks:
        	grunt:false
        log:
        	level: "silly"
        models:
        	connection: "mongo"
        	migrate: "alter"
    }, (error, server) ->
    	sails = server
    	Sails.services.rest.token 'https://mob.myvnc.com/org/oauth2/token/', {id:'healthCheckTESTAuth', secret:'pass1234'}, {id:'jokyip', secret:'pass1234'}, ['https://mob.myvnc.com/org/users']
    		.then (res) ->
    			sails.token = res.body.access_token
    			done error
    	
after (done) ->
	Sails.lower(done)