#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("pmix")
export GIS_PACKAGE_NAME_MAJOR=prrte
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/openpmix/prrte/releases/download/v${GIS_PACKAGE_VERSION}/prrte-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

run_configure
run_make

cp_log
create_module

run_test prte_info
