#!/bin/bash

/usr/lib/squid/security_file_certgen -c -s /var/spool/squid/ssl_db -M 20MB
svscan /services/
sleep infinity
