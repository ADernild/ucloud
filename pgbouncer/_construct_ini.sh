#!/bin/bash

# shellcheck source=/dev/null
{
  . "incl/all.sh"
  . "postgresql/_pg_globals.sh"
  . "postgresql/_utils.sh"
  . "postgresql/_create.sh"
  . "postgresql/_ssl.sh"
  # more files
}

# shellcheck source=/dev/null
source ../env/.env

DIR=etc/pgbouncer/

mkdir -p ${DIR} > /dev/null

echo "[databases]
${DBNAME} = host=localhost port=5432 dbname=${DBNAME} user=${DBUSER} password=${DBPASS}

[pgbouncer]
listen_port = 6432
listen_addr = 0.0.0.0
auth_type = trust
auth_file = userlist.txt
client_tls_sslmode = require
client_tls_key_file = ${UCLD_PATH[database]}/server.key
client_tls_cert_file = ${UCLD_PATH[database]}/server.crt
client_tls_ca_file = ${UCLD_PATH[database]}/root.key
server_tls_sslmode = require
logfile = pgbouncer.log
pidfile = pgbouncer.pid
ignore_startup_parameters=options
" > ${DIR}pgbouncer.ini

echo \""${DBUSER}"\" \""${DBPASS}"\" > ${DIR}userlist.txt
