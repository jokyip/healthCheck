#!/bin/sh

root=~/prod/healthCheck
sails=`which sails`

forever start --workingDir ${root} -a -l healthCheck.log ${sails} lift --prod