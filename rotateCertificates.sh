#!/bin/bash
set -e

/updateCertPem.sh
echo "console.log('certificate reload:', db.rotateCertificates('Auto reload certificate by Cron ($0)'))" > /tmp/rotateCertificates.js
mongosh --tls --tlsAllowInvalidHostnames -u rotateCertificates -p $PASSWD /tmp/rotateCertificates.js
