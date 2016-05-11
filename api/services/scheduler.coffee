schedule = require 'cron'
http = require 'needle'
status = require 'statuses'
Promise = require 'promise'
fs = require 'fs'
dateformat = require 'dateformat'

dir = '/etc/ssl/certs'
files = fs.readdirSync(dir).filter (file) -> /.*\.pem/i.test(file)
files = files.map (file) -> "#{dir}/#{file}"
ca = files.map (file) -> fs.readFileSync file

jobManager = {}

options = 
	timeout:	sails.config.promise.timeout
	ca:			ca
		
sendNotification = (instance) ->
	fulfill = (result) ->
		if sails.config.im.sendmsg
			fulfillmsg = (result) ->
				sails.log.info "Notification is sent to #{result.body.to} at #{dateformat(new Date(), 'dd/mmm/yyyy HH:MM')}"
			rejectmsg = (err) ->
				sails.log.error "Notification is sent with error: #{err} at #{dateformat(new Date(), 'dd/mmm/yyyy HH:MM')}"
			#send msg
			sendMsg(instance, result.body.access_token).then fulfillmsg, rejectmsg
		else 	
			sails.log.warn "Send notification is disabled. Please check system configuration."
	reject = (err) ->
		sails.log.error "Error in authorization token : " + err
	getToken().then fulfill, reject
	
sendMsg = (instance, todoAdminToken) ->
	return new Promise (fulfill, reject) ->

		opts = _.extend options, sails.config.http.opts,
			headers:
				Authorization:	"Bearer #{todoAdminToken}"
		
		data = 
			from: 	sails.config.im.adminjid
			to:		if instance.notifyTo then instance.notifyTo else "#{data.createdBy}@#{sails.config.im.xmpp.domain}"
			body: 	"""
					#{sails.config.im.txt}
					
					Time: #{dateformat(instance.createdAt, 'dd/mmm/yyyy HH:MM')}
					Name: #{instance.webServer.name} 
					URL: #{instance.webServer.url}
					Error Code: #{instance.statusCode}
					Error Message: #{instance.statusMsg}
					 					
					"""	

		http.post sails.config.im.url, data, opts, (err, res) ->			
			if err
				sails.log.debug "IM POST API with err"
				return reject err
			sails.log.debug "IM POST API responded"	
			fulfill res	
	
getToken = ->
	return new Promise (fulfill, reject) ->
		sails.services.rest.token sails.config.oauth2.tokenURL, sails.config.im.client, sails.config.im.user, sails.config.im.scope
			.then (res) ->
				sails.log.debug "getToken success"
				fulfill res
			.catch reject

module.exports = 
	add: (server) ->
		opts = _.extend options, sails.config.http.opts
		interval = Math.max server.interval, sails.config.webServer.access.interval
		job = new schedule.CronJob "0 0-59/#{interval} * * * *", ->
			http.request server.method, server.url, server.data, opts , (err, res) ->
		    	instance = 
		    		webServer: server
		    		createdBy: server.createdBy
		    		notifyTo: server.notifyTo
		    	if err
		    		sails.log.error err
		    		instance.statusCode = 500
		    		instance.statusMsg = err.message
		    		instance.statusType = sails.config.resLog.type.error
		    	else if res
		    		instance.statusCode = res.statusCode
		    		instance.statusMsg = status[res.statusCode]   	
		    		instance.statusType = if res.statusCode >= 400 then sails.config.resLog.type.error else sails.config.resLog.type.success					    			
	    		sails.log.info "Health Check result at #{dateformat(new Date(), 'dd/mmm/yyyy HH:MM')}: " + """ #{instance.webServer.name} | #{instance.webServer.url} | #{instance.statusCode} | #{instance.statusMsg} | #{instance.statusType} | #{instance.createdBy} | #{instance.notifyTo} """
	    		sails.models.reslog
	    			.create(instance)
	    			.then (result) ->
	    				if result.statusType == sails.config.resLog.type.error
	    					sendNotification(result)
	    			.catch (err) ->
	    				sails.log.error err
		, null, true, ''
		jobManager[server.id] = job
	
	update: (server) ->
		job = jobManager[server.id]
		job.stop()
		@add server				
	
	remove: (server) ->
		job = jobManager[server.id]
		job.stop()		
			