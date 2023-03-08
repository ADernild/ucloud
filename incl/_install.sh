#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# license       : EUPL-1.2 license
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

_ucld_::is_apt_available() {
  local _bool=false
  if "$(_ucld_::is_ucloud_env)" || [ -x "$(command -v apt)" ]; then _bool=true; fi
  echo "${_bool}"
}

_ucld_::install_packages() {
  local _bin _start _stop

  _start=$(date +%s)

  if ! "$(_ucld_::is_apt_available)"; then
    return
  fi

  _ucld_::h2 "Updating Apt"

  # NOTE: The PPA does not support Ubuntu 22.10.
  # You may follow the bottom link to build it from source tarball.
  # sudo add-apt-repository ppa:deadsnakes/ppa

  _ucld_::update_and_upgrade_apt

  for _bin in "${UCLD_INSTALL_PACKAGES[@]}"; do

    if "$(_ucld_::is_debian_running)" && [[ "${_bin}" == "python"* ]]; then
      return
    fi

    _ucld_::h2 "Installing ${_bin}"

    sudo apt install -y "$_bin" || :

    if [[ "$_bin" =~ ^python.* ]]; then
      # sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.11 1
      # sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/"${_bin}" 100
      sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/"${_bin}" 100

      pip install --upgrade pip
    fi

    _ucld_::h3 "You are now running $(${_bin%.*} --version 2>>logfile.log)"
  done

  _stop=$(date +%s)
  _ucld_::h3 "Install completed in $((_stop - _start)) seconds"

  echo
}

_ucld_::ask_install_packages() {
  if "$(_ucld_::is_apt_available)"; then
    if "$(_ucld_::ask "Do you want to install packages for Linux with apt")"; then
      _ucld_::install_packages
    fi
  fi
}
