#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#
# SSH Login
# <https://docs.hpc-type3.sdu.dk/intro/ssh-login.html#generate-a-new-ssh-key>
#
# Generating a new SSH key and adding it to the ssh-agent
# <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>
#
#====================================================

declare -A UCLOUD_SSH_KEY
declare -a UCLOUD_SSH_PATH

UCLOUD_SSH_KEY=(
  [key]="id_ed25519_ucloud"
  [password]="$(_ucld_::key_gen 32)"
)

UCLOUD_SSH_PATH=("${HOME}/.ssh" "${UCLD_PATH[env]}/.ssh")

_ucld_::update_ssh_config() {
  local _config _path

  for _path in "${UCLOUD_SSH_PATH[@]}"; do
    _config="${_path}/config"

    if grep -q "${UCLOUD_SSH_KEY[key]}" "${_config}" 2>>logfile.log; then
      return
    fi

    touch "${_config}"
    cat <<<"Host ""${HOSTNAME}""
  Hostname ""${HOSTNAME}""
  User ""${USER}""
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ""${UCLOUD_SSH_PATH[0]}/${UCLOUD_SSH_KEY[key]}""" >>"${_config}"

  done

}

_ucld_::update_ssh_agent() {
  local _lifetime=31536000

  eval "$(ssh-agent -s)"

  if [[ $(_ucld_::is_ucloud_execution) == true ]]; then
    ssh-add "${UCLOUD_SSH_PATH[0]}/${UCLOUD_SSH_KEY[key]}" -t "${_lifetime}"
  else
    ssh-add --apple-use-keychain "${UCLOUD_SSH_PATH[0]}/${UCLOUD_SSH_KEY[key]}" -t "${_lifetime}"
  fi

  _ucld_::h2 "${UCLOUD_SSH_KEY[key]} successfully added to the ssh agent"
  ssh-add -l
}

_ucld_::resources_storing() {
  cat <<EOF

On UCloud navigate to UCloud > Resources > SSH Keys > Create SSH key
https://cloud.sdu.dk/app/ssh-keys/create

Title:
ucloud

Public key:
$(cat "${UCLOUD_SSH_PATH[1]}/${UCLOUD_SSH_KEY[key]}.pub")

EOF
}

_ucld_::update_passfile() {
  local _path
  for _path in "${UCLOUD_SSH_PATH[@]}"; do
    echo "${UCLOUD_SSH_KEY[key]}:${UCLOUD_SSH_KEY[password]}" >>"${_path}/passfile"
  done
}

_ucld_::generate_ssh_key() {

  mkdir "${UCLOUD_SSH_PATH[1]}"

  if ssh-keygen -t ed25519 -N "${UCLOUD_SSH_KEY[password]}" -C "${USER}@${HOSTNAME}" -f "${UCLOUD_SSH_PATH[1]}/${UCLOUD_SSH_KEY[key]}"; then

    cp -v "${UCLOUD_SSH_PATH[1]}/${UCLOUD_SSH_KEY[key]}"* "${UCLOUD_SSH_PATH[0]}"

    cat <<EOF

Keep the passphrase used to generate the key:
${UCLOUD_SSH_KEY[password]}

It has been saved also under:
${UCLOUD_SSH_PATH[1]}/passfile

Enter this passphrase below 👇

EOF

    _ucld_::update_passfile
    _ucld_::update_ssh_config
    _ucld_::update_ssh_agent
    _ucld_::resources_storing

  fi

}
