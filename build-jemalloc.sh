#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}")
export PACKAGE_NAME=jemalloc
setup_env

export DOWNLOAD_URL="https://github.com/jemalloc/jemalloc/releases/download/${PACKAGE_VERSION}/jemalloc-${PACKAGE_VERSION}.tar.bz2"
wget_url

run_configure
run_make

cp_log
create_module

run_test jemalloc-config