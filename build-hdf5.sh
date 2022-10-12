#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?} ${CMAKE_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}" "cmake/${CMAKE_VERSION}")
export PACKAGE_NAME=hdf5
setup_env

export DOWNLOAD_URL="https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${PACKAGE_VERSION//./_}.tar.gz"
wget_url

if  [[ -d "/etc/opt/cray/release/" ]]; then
    CMAKE_EXTRA_ARGS="-DALLOW_UNSUPPORTED=ON \
                      -DHDF5_ENABLE_PARALLEL:BOOL=ON \
                      -DHDF5_BUILD_CPP_LIB:BOOL=OFF "
    export CMAKE_EXTRA_ARGS
fi
run_cmake_configure
run_cmake_build

cp_log
create_module

run_test h5cc