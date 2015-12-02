Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports = (req, res) ->
	sails.services.crud
		.find(req)
		.then res.ok
		.catch res.serverError