#!/bin/bash
set -e

# Save the env AUTO_ROTATE into a file, so that /rotateCertificates.sh can read this env value.
echo AUTO_ROTATE=$AUTO_ROTATE > /rotateCertificates.env

cd /scripts
./updateCertPem.sh
# Initialize the account which is required by /rotateCertificates.sh, so that it can login to the DB to rotate the cert.
mongod --port 57017 --fork --logpath /dev/null --noauth
mongosh --port 57017 ./initRotateAccount.js
mongod --shutdown
cd ..

echo "$ROTATE_CRON" "cd /scripts; ./rotateCertificates.sh" > /tmp/crontab.txt
crontab -u root /tmp/crontab.txt

cron
exec docker-entrypoint.sh "$@"
