###
ResLog.coffee

@description :: TODO: You might write a short summary of how this model works and what it represents here.
@docs        :: http://sailsjs.org/#!documentation/models
###

module.exports =

  	tableName:	'resLog'
		
	schema:		true
	
	autoCreatedAt: true
	
	attributes:
		webServer:
			model: 		'webserver'
			required:	true
		statusCode:				
			type: 		'integer'
			required:	true
		statusMsg:
			type: 		'string'
			required:	true
		statusType:
			type:		'string'	
		createdAt:
			type:		'datetime'
			defaultsTo:	new Date(0)
		createdBy:
			type: 		'string'
			required:	true