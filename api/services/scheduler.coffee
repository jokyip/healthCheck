schedule = require 'cron'
http = require 'needle'
status = require 'statuses'

jobManager = {}	

module.exports = 
	add: (server) ->
		interval = Math.max server.interval, sails.config.webServer.access.interval
		job = new schedule.CronJob "*/#{interval} * * * * *", ->
	    	http.get server.url, sails.config.http.opts, (err, res) ->
		    	if err
		    		sails.log.error err
		    		instance = 
		    			webServer: server
		    			statusCode: 500
		    			statusMsg: err.message
		    			createdBy: server.createdBy
		    	if res
		    		instance = 
		    			webServer: server
		    			statusCode: res.statusCode
		    			statusMsg: status[res.statusCode]
		    			createdBy: server.createdBy		    							    			
	    		sails.log.info """ #{instance.webServer.name} | #{instance.webServer.url} | #{instance.statusCode} | #{instance.statusMsg} | #{instance.createdBy} """
	    		sails.models.reslog
	    			.create(instance)
	    			.catch (err) ->
	    				sails.log err
		, null, true, ''
		jobManager[server.id] = job
	
	update: (server) ->
		job = jobManager[server.id]
		job.stop()
		@add server				
	
	remove: (server) ->
		job = jobManager[server.id]
		job.stop()
			