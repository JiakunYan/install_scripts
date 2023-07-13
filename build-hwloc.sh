#!/usr/bin/env bash

set -ex

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=hwloc
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://download.open-mpi.org/release/hwloc/v${GIS_PACKAGE_VERSION%.*}/hwloc-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

if [ "$(get_platform_name)" == "delta" ]; then
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} --disable-rsmi --enable-gl=no"
fi
run_configure --disable-opencl ${CONFIG_EXTRA_ARGS}
run_make

cp_log
create_module

# test
module load ${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}
which lstopo-no-graphics