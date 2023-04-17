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
  pgbouncer_path=$(curl -s "https://www.pgbouncer.org/downloads/" | grep -Eo 'files[^"]+' | head -1)
  pgbouncer_version=$(echo "$pgbouncer_path" | cut -b 14-29)

  mkdir "${UCLD_PATH[install]}"

  curl -sSL "https://www.pgbouncer.org/downloads/${pgbouncer_path}" -o "${UCLD_PATH[install]}/${pgbouncer_version}.tar.gz"
  tar -xvf "${UCLD_PATH[install]}/${pgbouncer_version}.tar.gz" --directory="${UCLD_PATH[install]}"

  ./configure --prefix=/usr/local
  make
  make install
fi


