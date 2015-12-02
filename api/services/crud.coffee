Promise = require 'promise'
util = require 'util'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports = 
	create: (req) ->
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		
		new Promise (fulfill, reject) ->
			Model.create(data)
				.then (newInstance) ->
					fulfill(newInstance)
				.catch reject
				
	find: (req) ->
		Model = actionUtil.parseModel req
		cond = actionUtil.parseCriteria req

		count = Model.count()
		 	.where( cond )
			.toPromise()	
		query = Model.find()
		 	.where( cond )
			.populateAll()
			.limit( actionUtil.parseLimit(req) )
			.skip( actionUtil.parseSkip(req) )
			.sort( actionUtil.parseSort(req) )
			.toPromise()
				
		new Promise (fulfill, reject) ->
			Promise.all([count, query])
				.then (data) ->
					fulfill
						count:		data[0]
						results:	data[1]
				.catch reject
				
	_findOrCreate: (req, Model, cond, data) ->
		new Promise (fulfill, reject) ->
			Model.findOrCreate(cond, data)
				.then (newInstance) ->					
					fulfill(newInstance)
				.catch reject