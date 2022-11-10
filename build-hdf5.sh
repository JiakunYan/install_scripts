#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake")
export GIS_PACKAGE_NAME_MAJOR=hdf5
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${GIS_PACKAGE_VERSION//./_}.tar.gz"
wget_url

run_cmake_configure ${CONFIG_EXTRA_ARGS}
run_cmake_build
run_cmake_install

cp_log
create_module