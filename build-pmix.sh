#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=pmix
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/openpmix/openpmix/releases/download/v${GIS_PACKAGE_VERSION}/pmix-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

run_configure
run_make

cp_log
create_module

run_test pmix_info
