FROM ubuntu:jammy

ENV SQUID_VERSION="5.2-1ubuntu4" \
    SQUID_SSL_DIR="/squid_ssl"

# install squid with openssl feature
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install      \
                openssl     \
                vim         \
                curl        \
                net-tools   \
                daemontools \
                squid-openssl=${SQUID_VERSION} sudo && \
    rm -rf /var/lib/apt/lists/* && mkdir -p ${SQUID_SSL_DIR}

# Generate certificates
WORKDIR ${SQUID_SSL_DIR}
RUN sed -i '240 i keyUsage = cRLSign, keyCertSign' /etc/ssl/openssl.cnf && mkdir -p ${SQUID_SSL_DIR}
RUN openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -extensions v3_ca \
	       -keyout squid-self-signed.key -out squid-self-signed.crt \
	       -subj '/C=US/ST=New York/L=New York/O=IT/OU=HostingTeam/CN=localhost/emailAddress=test@mail.com' && \
            openssl x509 -in squid-self-signed.crt -outform DER -out squid-self-signed.der && \
            openssl x509 -in squid-self-signed.crt -outform PEM -out squid-self-signed.pem

RUN chmod 666 -R ${SQUID_SSL_DIR}/*

# adding squid generated CA cert in trusted 
RUN cp ${SQUID_SSL_DIR}/squid-self-signed.pem /usr/local/share/ca-certificates/squid-self-signed.crt && \
    sudo update-ca-certificates

# replace default configs
COPY storeid_rewrite.conf /etc/squid/storeid_rewrite.conf
COPY squid.conf /etc/squid/squid.conf
COPY --chmod=777 run.sh /run.sh
COPY --chmod=777 services /services

# creating cache dir
RUN chmod 777 -R /usr/sbin/squid /run.sh /run
RUN /usr/lib/squid/security_file_certgen -c -s /var/spool/squid/ssl_db -M 20MB

EXPOSE 3128

ENTRYPOINT [ "/run.sh" ]
