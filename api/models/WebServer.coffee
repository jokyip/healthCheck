module.exports =

	tableName:	'webServer'

	schema:	true

	attributes:
		name:
			type:	'string'
			required:	true
			unique:	true
		url:				
			type:	'string'
			required:	true
		interval:
			type:	'integer'
			defaultsTo:	5	
		createdAt:
			type:	'datetime'
			defaultsTo:	new Date()
		createdBy:
			type:	'string'
			required:	true
		updatedAt:
			type:	'datetime'
			defaultsTo:	new Date()