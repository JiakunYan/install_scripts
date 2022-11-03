#!/usr/bin/env bash

source include/common.sh

GIS_PACKAGE_DEPS=("cmake" "openmpi")
if [ ${GIS_COMM_BACKEND} == "ofi" ]; then
  GIS_PACKAGE_DEPS+=("libfabric")
fi
export GIS_PACKAGE_DEPS
export GIS_PACKAGE_NAME_MAJOR=lci
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/uiuc-hpc/LC.git"
wget_url

if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  CONFIG_EXTRA_ARGS="-DLCI_DEBUG=ON"
elif [ ${GIS_BUILD_TYPE} == "release" ]; then
  CONFIG_EXTRA_ARGS="-DLCI_USE_PERFORMANCE_COUNTER=OFF"
fi
run_cmake_configure \
    -DLCI_SERVER=${GIS_COMM_BACKEND} \
    -DLCI_PACKET_SIZE=69632 \
    -DLCI_SERVER_NUM_PKTS_DEFAULT=16384 \
    ${CONFIG_EXTRA_ARGS}
run_cmake_build
run_cmake_install

cp_log
create_module