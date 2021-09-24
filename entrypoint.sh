#!/bin/bash
set -e

/updateCertPem.sh
cron
exec docker-entrypoint.sh "$@"
