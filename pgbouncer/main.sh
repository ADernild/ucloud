#!/bin/bash

# Installing pgbouncer

echo "Installing pgbouncer"
#shellcheck source=/dev/null
. pgbouncer/_dep.sh

# Constructing .ini

echo "Constructing config for pgbouncer"
# shellcheck source=/dev/null
. pgbouncer/_construct_ini.sh

# Starting pgbouncer in detached mode

echo "Starting pgbouncer service"
cd etc/pgbouncer/ > /dev/null || exit
pgbouncer -d pgbouncer.ini
cd ../../ > /dev/null
