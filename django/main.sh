#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# shellcheck disable=SC1090,SC1091
{
  . "incl/all.sh"
  . "${UCLD_PATH[env]}/.env" 2>>logfile.log || true
  . "django/_utils.sh"
  . "postgresql/_utils.sh"
  # more files
}

cat "django/README.txt"

_dj_repo=""

if [[ ${UCLD_PATH[django]+_} ]]; then

  _dj_repo="${UCLD_PATH[django]}"

else

  _ucld_::h2 "Please select a valid Django repository"

  select _dj_repo in $(dirname "${UCLD_PATH[work]}"/*/manage.py || true); do
    test -n "${_dj_repo}" && break
    # echo ">>> Invalid Selection"
    _ucld_::alert ">>> Invalid Selection"
  done

fi

if [[ "${_dj_repo}" ]]; then
  if [[ -f "${_dj_repo}/manage.py" ]]; then

    _ucld_::h3 "You have selected repo ${_dj_repo}"

    _ucld_::update_settings "UCLD_DIR[django]=""${_dj_repo##*/}"""

    cd_ "$_dj_repo"

    _ucld_::dj_collectstatic
    _ucld_::dj_install_dependencies

    if "$(_ucld_::is_postgresql_server_running)"; then

      if "$(_ucld_::ask_2 "Do you want to run migrations")"; then
        _ucld_::dj_running_migrations
      fi

      if "$(_ucld_::ask_2 "Do you want to create a superuser")"; then
        _ucld_::dj_create_superuser
      fi

      python manage.py runserver

    else
      _ucld_::warning postgresql
    fi

    _ucld_::back_to_script_dir_

  else
    _ucld_::exception "No manage.py file found in ${_dj_repo} directory\nAre you sure it is a valid Django 🐍 app?"
  fi
fi
