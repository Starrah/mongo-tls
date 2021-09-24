#!/bin/bash
set -e

PASSWD=`dd if=/dev/urandom bs=12 count=1 | base64`
sed 's/$PASSWD/'$PASSWD'/g' /docker-entrypoint-initdb.d/02-initRotateAccount.js > /tmp/02-initRotateAccount.js
cat /tmp/02-initRotateAccount.js > /docker-entrypoint-initdb.d/02-initRotateAccount.js
sed 's/$PASSWD/'$PASSWD'/g' /rotateCertificates.sh > /tmp/rotateCertificates.sh
cat /tmp/rotateCertificates.sh > /rotateCertificates.sh 
