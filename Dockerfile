FROM mongo:latest

RUN apt-get update && apt-get install -y cron
ADD --chown=mongodb:mongodb 01-initRotateAccount.sh 02-initRotateAccount.js /docker-entrypoint-initdb.d/
ADD updateCertPem.sh rotateCertificates.sh crontab.txt entrypoint.sh /
RUN chmod u+x /docker-entrypoint-initdb.d/01-initRotateAccount.sh docker-entrypoint-initdb.d/02-initRotateAccount.js /updateCertPem.sh /rotateCertificates.sh /entrypoint.sh && chmod a+w /rotateCertificates.sh

ENV AUTO_ROTATE=true
RUN crontab -u root /crontab.txt

ENTRYPOINT ["/entrypoint.sh", "--tlsCertificateKeyFile", "/cert.pem"]
CMD ["--tlsMode", "requireTLS", "--sslDisabledProtocols", "TLS1_0,TLS1_1"]
