#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=jemalloc
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/jemalloc/jemalloc/releases/download/${GIS_PACKAGE_VERSION}/jemalloc-${GIS_PACKAGE_VERSION}.tar.bz2"
wget_url

run_configure
run_make

cp_log
create_module

run_test jemalloc-config