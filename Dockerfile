FROM node:4-slim

WORKDIR /usr/src/app

ADD https://github.com/jokyip/healthCheck/archive/master.tar.gz /tmp

RUN apt-get update && \
	cd /usr/src/app &&\
	tar --strip-components=1 -xzf /tmp/master.tar.gz &&\
	rm /tmp/master.tar.gz &&\
	npm install coffee-script -g && \
	npm install bower -g && \
	npm install &&\
	apt-get -y install git &&\
	bower install --allow-root &&\
	ln -s /usr/local/bin/coffee /usr/bin/coffee

ENTRYPOINT npm start