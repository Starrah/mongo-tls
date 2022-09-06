FROM mongo:latest

RUN apt-get update && apt-get install -y cron
ADD entrypoint.sh /
ADD scripts /scripts
RUN chmod -R u+x /entrypoint.sh /scripts

ENV AUTO_ROTATE="true"
# rotate cert EVERYDAY at 0:00
ENV ROTATE_CRON="0 0 * * *"
EXPOSE 27017
ENTRYPOINT ["/entrypoint.sh", "--tlsCertificateKeyFile", "/cert.pem"]
CMD ["--tlsMode", "requireTLS", "--tlsDisabledProtocols", "TLS1_0,TLS1_1"]
