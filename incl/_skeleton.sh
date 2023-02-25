#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

_ucld_::build_skeleton() {
  local _key _option _echo
  _option=${1:-""}
  _echo=0

  for _key in "${!UCLD_DIR[@]}"; do
    value="${UCLD_PATH["${_key}"]}"
    if [ ! -d "${value}" ]; then
      if [ ${_echo} -eq 0 ]; then
        echo -e "\nBuilding skeleton...\n"
        _echo=1
      fi
      mkdir "${value}"
    elif [[ "${_option}" == "delete" ]]; then
      rm "${value}"
    fi
  done

  if [[ ! -f "${UCLD_PATH[env]}/settings.conf" ]]; then
    cp "./settings.conf" "${UCLD_PATH[env]}/settings.conf"
  fi
}

_ucld_::startup_check() {
  _ucld_::build_skeleton "$@"
  _ucld_::update_bashrc
}
