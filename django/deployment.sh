#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# shellcheck source=/dev/null
{
  . "/work/env/.env"
  . "/work/ucloud/incl/_debug.sh"
  . "/work/ucloud/django/_utils.sh"
  # more files
}

_ucld_::unofficial_bash_strict_mode "on"

_ucld_::dj_collectstatic
_ucld_::dj_install_dependencies
python manage.py runserver
