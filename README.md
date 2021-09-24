MongoDB TLS Docker Image
=========================================
[![](https://img.shields.io/docker/v/starrah/mongo-tls)](https://hub.docker.com/r/starrah/mongo-tls) [![](https://img.shields.io/docker/image-size/starrah/mongo-tls)](https://hub.docker.com/r/starrah/mongo-tls) [![](https://img.shields.io/docker/pulls/starrah/mongo-tls)](https://hub.docker.com/r/starrah/mongo-tls) [![](https://img.shields.io/github/stars/Starrah/mongo-tls?style=social)](https://github.com/Starrah/mongo-tls)

A docker image which can easily enable the TLS connection for MongoDB, and automatically reload the certificate. Be best when using along with Certbot etc.
[Docker Hub Page](https://hub.docker.com/r/starrah/mongo-tls) | [Github](https://github.com/Starrah/mongo-tls)

## Usage
### With `docker run`
```shell
docker run -d -v mongo_data:/data/db -v path_to_cert_dir:/cert -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=some_password -p 27017:27017 --restart unless-stopped starrah/mongo-tls:latest
```
Please replace the `path_to_cert_dir` with the directory which saves the certificate in your host machine, and replace the `some_password` with your DB's root password.
### With docker-compose
Here is a sample `docker-compose.yml`:
```yaml=
version: '3'

services:
  mongo:
    build: .
    volumes:
      - mongo-data:/data/db
      - path_to_cert_dir:/cert
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: some_password
    restart: unless-stopped
volumes:
  mongo-data: {}
```
### Verify
If your certificate is signed by a trusted CA, and you have made the DNS resolution to your machine correctly:
```shell
docker run -it --network host --entrypoint mongosh mongo:latest mongodb://your_domain_name:27017/ --tls -u root -p some_password
```
Else, you can try to connect with `localhost` and `--tlsAllowInvalidHostnames`:
```shell
docker run -it --network host --entrypoint mongosh mongo:latest mongodb://localhost:27017/ --tls -u root -p some_password --tlsAllowInvalidHostnames
```

## Config
### Certificate
When a container of this image is started, it reads the certificate file from `/cert` directory. So you should put the certificate at `/cert` directory by volume mounting, like shown above.

The certificate directory should either:
- has a `.pem` file, which contains the private key of the certificate, the X.509 certificate and all CA certificates in the certificate's trust chain.
- has a `.key` file, which contains the private key of the certificate, and a `.crt` file, which contains the X.509 certificate and all CA certificates in the certificate's trust chain.
### Environment
- In this image, the following environments are defined:

| Environment | default | description |
| -------- | -------- | -------- |
| AUTO_ROTATE     | true   | Whether to automatically reload the certificate with [db.rotateCertifiates](https://docs.mongodb.com/manual/reference/method/db.rotateCertificates/#mongodb-method-db.rotateCertificates). (Frequency: every day)    |

- Besides, since this image is built from `mongo:latest`, all other environments defined in the [`mongo` official docker image](https://hub.docker.com/_/mongo) is still available.
### Command arguments
- This image is configured with the following command arguments:
    - `CMD ["--tlsMode", "requireTLS", "--sslDisabledProtocols", "TLS1_0,TLS1_1"]`.
    - So if you don't give any args when executing `docker run`, the default args will be used. In this case, the server can only be connected with TLS 1.2 or above, and connection without TLS will be refused.
    - If you give args when executing `docker run`, your args will override the default args, and be passed along to `mongod`.

## Bugs & Contribution
Feel free to open an issue at [Issues](https://github.com/Starrah/mongo-tls/issues) and make [PRs](https://github.com/Starrah/mongo-tls/pulls)!
