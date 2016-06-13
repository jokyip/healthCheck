FROM node:4-slim

WORKDIR /usr/src/app

ADD https://github.com/jokyip/healthCheck/archive/master.tar.gz /tmp

RUN apt-get update && \
	apt-get -y install git && \
	apt-get clean && \
	cd /usr/src/app && \
	tar --strip-components=1 -xzf /tmp/master.tar.gz && \
	rm /tmp/master.tar.gz && \
	npm install bower coffee-script -g && \
	npm install && \
	bower install --allow-root && \
	node_modules/.bin/gulp && \
	ln -s /usr/local/bin/coffee /usr/bin/coffee

ENTRYPOINT npm start --prod