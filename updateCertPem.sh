#!/bin/bash
set -e

# shellcheck disable=SC2144
if [ -f /cert/*.pem ]; then
	cat /cert/*.pem > /cert.pem
elif [ -f /cert/*.key ] && [ -f /cert/*.crt ]; then
	cat /cert/*.key /cert/*.crt > /cert.pem
else
	echo "No cert file is found at /cert ! please mount the directory which contains cert file(s) (either .pem or .crt & .key) to the container's /cert directory!" >&2
	exit 1
fi
