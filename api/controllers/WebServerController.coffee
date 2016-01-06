###
WebServerController

@description :: Server-side logic for managing webservers
@help        :: See http://links.sailsjs.org/docs/controllers
###
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	create: (req, res) ->
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		if !data.notifyTo
			data.notifyTo = "#{data.createdBy}@#{sails.config.im.xmpp.domain}"
		Model.create(data)
			.then (newInstance) ->
				sails.services.scheduler.add newInstance
				res.created(newInstance)
			.catch res.serverError
			
	update: (req, res) ->
		pk = actionUtil.requirePk(req)
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		if !data.notifyTo
			data.notifyTo = "#{data.createdBy}@#{sails.config.im.xmpp.domain}"	
		Model
			.update({id: pk},data)
      		.then (updatedInstance) ->
				sails.services.scheduler.update updatedInstance[0]
				res.ok()
			.catch res.serverError
			
	destroy: (req, res) ->
		pk = actionUtil.requirePk(req)
		Model = actionUtil.parseModel(req)
			
		Model
			.destroy({id: pk})
      		.then (deletedInstance) ->
				sails.services.scheduler.remove deletedInstance[0]
				res.ok()
			.catch res.serverError		
		
				