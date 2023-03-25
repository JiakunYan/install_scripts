#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake")
export GIS_PACKAGE_NAME_MAJOR=hdf5
if [ "$(get_platform_name)" == "ookami" ]; then
  # -mcpu=a64fx doesn't work for hdf5 for some reason
  export CFLAGS=""
  export CXXFLAGS=""
fi
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${GIS_PACKAGE_VERSION//./_}.tar.gz"
wget_url

run_cmake_configure ${CONFIG_EXTRA_ARGS}
run_cmake_build
run_cmake_install

cp_log
create_module