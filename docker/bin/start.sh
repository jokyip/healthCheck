#!/bin/sh

docker run -it --link mongo:db -p 3000:3000 -v /home/jeffery/git/healthCheck/docker/config/development.coffee:/usr/src/app/config/env/development.coffee -v /etc/ssl/certs:/etc/ssl/certs -v /usr/share/ca-certificates:/usr/share/ca-certificates -v /usr/local/share/ca-certificates:/usr/local/share/ca-certificates --name healthCheck jokyip/healthcheck 