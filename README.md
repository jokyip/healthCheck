# healthCheck

Monitor registered web applications online service availability. The application will send request to web server URL in specified interval (in minute) and log the response status. If error status (code >= 400) is found, a notification message will be sent to user's IM account.


Server API
---------------------------------------------------------
## web server
		
* api

	```
	get /api/webServer - list your registered web servers for specified pagination/sorting parameters skip, limit, sort
	post /api/webServer - create a web server item with the specified attributes excluding id
    put /api/webServer/:id - update web server attributes of the specified id
    delete /api/webServer/:id - delete web server item of the specified id
    
	```

## response log
	
* api
	```
    get /api/resLog - list all registered web applications response status for specified pagination/sorting parameters skip, limit, sort
	```


Configuration
=============

*   git clone https://github.com/jokyip/healthCheck.git
*   cd healthCheck
*   npm install && bower install
*   update environment variables in config/env/development.coffee for server
```
port: 3000
connections:
	mongo:
		driver:		'mongodb'
		host:		'localhost'
		port:		27017
		user:		'healthCheckrw'
		password:	'password'
		database:	'healthCheck'
```

*	update environment variables in www/js/env.coffee for client
```
path: '/healthCheck'

# proxy server setting (if required)
agent = require 'https-proxy-agent'

http:
	opts:
		agent:	new agent("http://proxy.server.com:8080")

```

*	node_modules/.bin/gulp
*	sails lift --dev
