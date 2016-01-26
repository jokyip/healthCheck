request = require 'supertest'

describe 'ResLogController', ->

	describe 'CRUD', ->
		it 'Read Reslog', (done) ->
			request(sails.hooks.http.app)
			.get('/api/resLog')
			.set('Authorization',"Bearer #{sails.token}")
			.expect(200, done)