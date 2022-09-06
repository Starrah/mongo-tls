#!/bin/bash
set -e

# Load the env AUTO_ROTATE from a file
# shellcheck disable=SC2046
export $(cat /rotateCertificates.env | xargs)

./updateCertPem.sh
if [ ''$AUTO_ROTATE == 'true' ]; then
  echo "console.log('certificate reload:', db.rotateCertificates('Auto reload certificate by Cron ($0)'))" > /tmp/rotateCertificates.js
  mongosh --tls --tlsAllowInvalidHostnames --tlsAllowInvalidCertificates -u rotateCertificates -p "$(cat /mongo.user.rotateCertificates.pwd)" /tmp/rotateCertificates.js
fi
