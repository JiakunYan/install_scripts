#!/usr/bin/env bash

source include/common.sh

GIS_PACKAGE_DEPS=("gcc" "cmake" "openmpi")
if [ ${GIS_COMM_BACKEND} == "ofi" ]; then
  GIS_PACKAGE_DEPS+=("libfabric")
fi
export GIS_PACKAGE_DEPS
export GIS_PACKAGE_NAME_MAJOR=lci
setup_env "$@"

export GIS_DOWNLOAD_URL="git@github.com:uiuc-hpc/LC.git"
wget_url

if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  DEBUG_EXTRA_ARGS="-DLCI_DEBUG=ON"
fi
run_cmake_configure \
    -DLCI_SERVER=${GIS_COMM_BACKEND} \
    -DLCI_PACKET_SIZE=69632 \
    -DLCI_SERVER_NUM_PKTS=16384 \
    -DLCI_SERVER_MAX_RCVS=1024 \
    ${DEBUG_EXTRA_ARGS}
run_cmake_build

cp_log
create_module