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


if ! _ucld_::is_package_installed pgbouncer; then
  if ! _ucld_::is_package_installed wget; then
    apt-get wget
    ## Adding PGDG apt repository
    wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
    su -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main' >> /etc/apt/sources.list.d/pgdg.list"


    apt-get update \
      && apt-get install -y pgdg-keyring
    apt-get install -y pgbouncer
  fi
fi


