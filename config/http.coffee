express = require 'express'
			
module.exports = 
	http:
		middleware:
			static: express.static('www')
			prefix: (req, res, next) ->
				p = new RegExp('^' + sails.config.path)
				req.url = req.url.replace(p, '')
				next()
			resHeader: (req, res, next) ->
				res.set sails.config.csp
				next()
			order: [
				'startRequestTimer'
				'cookieParser'
				'session'
				'prefix'
				'resHeader'
				'bodyParser'
				'compress'
				'methodOverride'
				'$custom'
				'router'
				'static'
				'www'
				'favicon'
				'404'
				'500'
			]