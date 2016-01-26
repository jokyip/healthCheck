request = require 'supertest'

describe 'WebServerController', ->

	describe 'CRUD', ->
	
		id = null
	
		it 'Create WebServer', (done) ->
			request(sails.hooks.http.app)
			.post('/api/webServer')
			.send({ name: 'unitTest', url: 'http://www.google.com.hk', createdBy:'jokyip' })
			.set('Authorization',"Bearer #{sails.token}")
			.expect (res)->
				id = res.body.id
			.expect(201, done)
			
		it 'Read WebServer', (done) ->
			request(sails.hooks.http.app)
			.get("/api/webServer/#{id}")
			.set('Authorization',"Bearer #{sails.token}")
			.expect(200, done)
			
		it 'Delete WebServer', (done) ->
			request(sails.hooks.http.app)
			.del("/api/webServer/#{id}")
			.set('Authorization',"Bearer #{sails.token}")
			.expect(200, done)		