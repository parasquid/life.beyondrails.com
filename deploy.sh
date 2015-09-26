#!/bin/sh
hugo --theme=hyde-x
s3cmd sync public/* s3://life.beyondrails.com -v --no-mime-magic
