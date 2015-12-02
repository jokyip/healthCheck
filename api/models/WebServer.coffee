###
WebServer.coffee

@description :: TODO: You might write a short summary of how this model works and what it represents here.
@docs        :: http://sailsjs.org/#!documentation/models
###

module.exports =

    tableName:	'webServer'
		
	schema:		true
	
	autoUpdatedAt: true
	
	autoCreatedAt: true
	
	attributes:
		name:
			type: 		'string'
			required:	true
		url:				
			type: 		'string'
			required:	true
		interval:
			type: 		'integer'
			defaultsTo:	5
		createdAt:
			type:		'datetime'
			defaultsTo:	new Date()
		createdBy:
			type: 		'string'
			required:	true
		updatedAt:
			type:		'datetime'
			defaultsTo:	new Date()	
			
	afterCreate: (newlyInsertedRecord, cb) ->
		sail.log "afterCreate"
		sails.services.scheduler.add newlyInsertedRecord
		cb()
	
	afterUpdate: (updatedRecord, cb) ->
		sail.log "afterUpdate"
		sails.services.scheduler.update updatedRecord
		cb()
	
	afterDestroy: (destroyedRecords, cb) ->
		sail.log "afterDestroy"
		_.each destroyedRecords, (destroyedRecord) ->
			sail.log.silly destroyedRecord
			sails.services.scheduler.remove destroyedRecord
		cb()
