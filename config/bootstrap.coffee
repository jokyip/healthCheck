module.exports = 
	bootstrap:	(cb) ->		
		sails.models.webserver
			.find()
			.then (servers) ->
				_.each servers, (server) ->
					sails.services.scheduler.add server
			.catch (err) ->
				sails.log err
		cb()