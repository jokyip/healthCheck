schedule = require 'cron'
http = require 'needle'
status = require 'statuses'

jobManager = {}	

module.exports = 
	add: (server) ->
		opts = if server.proxy then sails.config.http.opts else ""
		interval = Math.max server.interval, sails.config.webServer.access.interval
		job = new schedule.CronJob "*/#{interval} * * * * *", ->
	    	http.get server.url, opts , (err, res) ->
		    	instance = 
		    		webServer: server
		    		createdBy: server.createdBy		    				    	
		    	if err
		    		sails.log.error err
		    		instance.statusCode = 500
		    		instance.statusMsg = err.message
		    		instance.statusType = sails.config.resLog.type.error
		    	else if res
		    		instance.statusCode = res.statusCode
		    		instance.statusMsg = status[res.statusCode]   	
		    		instance.statusType = if res.statusCode >= 400 then sails.config.resLog.type.error else sails.config.resLog.type.success					    			
	    		sails.log.info """ #{instance.webServer.name} | #{instance.webServer.url} | #{instance.statusCode} | #{instance.statusMsg} | #{instance.statusType} | #{instance.createdBy} """
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
			