request = require 'supertest'

describe 'WebServerController', ->

	describe 'CRUD', ->
	
		id = null
	
		it 'Create WebServer', ->
			request(sails.hooks.http.app)
			.post('/api/webServer')
			.send({ name: 'unitTest', url: 'http://abc.com', interval: 1, createdBy:'jokyip' })
			.set('Authorization',"Bearer #{sails.token}")
			.expect (res)->
				id = res.body.id
			.expect(201)
			
		it 'Read WebServer', ->
			request(sails.hooks.http.app)
			.get("/api/webServer/#{id}")
			.set('Authorization',"Bearer #{sails.token}")
			.expect(200)
			
		it 'Delete WebServer', (done) ->
			request(sails.hooks.http.app)
			.del("/api/webServer/#{id}")
			.set('Authorization',"Bearer #{sails.token}")
			.expect(200, done)		