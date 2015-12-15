#!/bin/sh

root=~/prod/healthCheck
sails=`which sails`
port=8014

forever start --workingDir ${root} -a -l healthCheck.log ${sails} lift --prod --port ${port}