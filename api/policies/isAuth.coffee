passport = require 'passport'
bearer = require 'passport-http-bearer'
Promise = require 'promise'

# check if oauth2 bearer is available
verifyToken = (token) ->
	oauth2 = sails.config.oauth2
	
	return new Promise (fulfill, reject) ->
		sails.services.rest.get token, oauth2.verifyURL			
			.then (res) -> 
				# check required scope authorized or not
				scope = res.body.scope.split(' ')				
				result = _.intersection scope, oauth2.scope
				if result.length != oauth2.scope.length
					return reject('Unauthorized access to #{oauth2.scope}')
					
				# create user
				# otherwise check if user registered before (defined in model.User or not)
				user = _.pick res.body.user, 'url', 'username', 'email'
				fulfill(user)
			.catch reject
			
passport.use 'bearer', new bearer.Strategy {}, (token, done) ->
	fulfill = (user) ->
		user.token = token
		done(null, user)
	reject = (err) ->
		done(null, false, message: err)
	verifyToken(token).then fulfill, reject
	
module.exports = (req, res, next) ->
	middleware = passport.authenticate('bearer', { session: false })
	middleware req, res, ->
		next()