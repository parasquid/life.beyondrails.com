#!/bin/sh
killall hugo # make sure no hugo server is running since that can mess things up
hugo
s3cmd sync public/* s3://life.beyondrails.com -v --no-mime-magic
