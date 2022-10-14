#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?} ${HPX_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}" "hpx/${HPX_VERSION}")
export PACKAGE_NAME=cppuddle
setup_env

export DOWNLOAD_URL="https://github.com/JiakunYan/CPPuddle.git"
wget_url

run_cmake_configure \
    -DCPPUDDLE_WITH_TESTS=OFF \
    -DCPPUDDLE_WITH_COUNTERS=OFF \
    -DCPPUDDLE_WITH_MULTIGPU_SUPPORT=OFF \
    -DCPPUDDLE_WITH_HPX=ON
run_cmake_build
cp_log

create_module