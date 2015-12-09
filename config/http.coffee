express = require 'express'
			
module.exports = 
	http:
		middleware:
			static: express.static('www')
			resHeader: (req, res, next) ->
				res.set sails.config.csp
				next()
			order: [
				'startRequestTimer'
				'cookieParser'
				'session'
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