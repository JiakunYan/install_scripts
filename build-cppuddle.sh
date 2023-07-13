#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=()
export GIS_PACKAGE_NAME_MAJOR=cppuddle
setup_env "$@"

hpx_to_load="hpx"
if [ "${GIS_BUILD_TYPE}" == "debug" ]; then
  hpx_to_load="hpx/local-debug"
fi
GIS_PACKAGE_DEPS+=("${hpx_to_load}")
load_module

export GIS_DOWNLOAD_URL="https://github.com/JiakunYan/CPPuddle.git"
wget_url

if [ "$(get_platform_name)" == "perlmutter" ]; then
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
  -DCPPUDDLE_WITH_NUMBER_GPUS=4 \
  -DCPPUDDLE_WITH_MAX_NUMBER_WORKERS=64"
fi

run_cmake_configure \
    -DCPPUDDLE_WITH_TESTS=OFF \
    -DCPPUDDLE_WITH_COUNTERS=OFF \
    -DCPPUDDLE_WITH_HPX=ON \
    -DCPPUDDLE_WITH_HPX_AWARE_ALLOCATORS=ON \
    ${CONFIG_EXTRA_ARGS}
run_cmake_build
run_cmake_install
cp_log

create_module