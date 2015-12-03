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
		proxy:
			type: 		'boolean'
			defaultsTo:	false	
		createdAt:
			type:		'datetime'
			defaultsTo:	new Date()
		createdBy:
			type: 		'string'
			required:	true
		updatedAt:
			type:		'datetime'
			defaultsTo:	new Date()