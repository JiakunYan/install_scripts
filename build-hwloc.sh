#!/usr/bin/env bash

set -ex

source include/common.sh

: ${GCC_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}")
export PACKAGE_NAME=hwloc
setup_env

export DOWNLOAD_URL="https://download.open-mpi.org/release/hwloc/v${PACKAGE_VERSION%.*}/hwloc-${PACKAGE_VERSION}.tar.gz"
wget_url

export AT_EXTRA_ARGS="--disable-opencl"
run_configure
run_make

cp_log
create_module

# test
module load ${PACKAGE_NAME}/${PACKAGE_NAME_SUFFIX}
which lstopo-no-graphics