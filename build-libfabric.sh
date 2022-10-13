#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}")
export PACKAGE_NAME=libfabric
setup_env

export DOWNLOAD_URL="https://github.com/ofiwg/libfabric/releases/download/v${PACKAGE_VERSION}/libfabric-${PACKAGE_VERSION}.tar.bz2"
wget_url

run_configure
run_make
cp_log

create_module

run_test fi_info

