#!/usr/bin/env bash

set -ex

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=hwloc
setup_env "$@"

export GIS_DOWNLOAD_URL="https://download.open-mpi.org/release/hwloc/v${GIS_PACKAGE_VERSION%.*}/hwloc-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

run_configure --disable-opencl
run_make

cp_log
create_module

# test
module load ${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}
which lstopo-no-graphics