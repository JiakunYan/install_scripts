#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("hpx")
export GIS_PACKAGE_NAME_MAJOR=cppuddle
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/JiakunYan/CPPuddle.git"
wget_url

run_cmake_configure \
    -DCPPUDDLE_WITH_TESTS=OFF \
    -DCPPUDDLE_WITH_COUNTERS=OFF \
    -DCPPUDDLE_WITH_MULTIGPU_SUPPORT=OFF \
    -DCPPUDDLE_WITH_HPX=ON
run_cmake_build
run_cmake_install
cp_log

create_module