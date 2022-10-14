#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?} ${CMAKE_VERSION:?} ${LIBFABRIC_VERSION:?} ${OPENMPI_VERSION:?} ${GIS_LCI_BACKEND:?}
export GIS_PACKAGE_DEPS=(
        "gcc/${GCC_VERSION}"
        "cmake/${CMAKE_VERSION}"
        "libfabric/${LIBFABRIC_VERSION}"
        "openmpi/${OPENMPI_VERSION}"
    )
export GIS_PACKAGE_NAME_MAJOR=lci
setup_env "$@"

export GIS_DOWNLOAD_URL="git@github.com:uiuc-hpc/LC.git"
wget_url

if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  DEBUG_EXTRA_ARGS="-DLCI_DEBUG=ON"
fi
run_cmake_configure \
    -DLCI_SERVER=${GIS_LCI_BACKEND} \
    -DLCI_PACKET_SIZE=69632 \
    ${DEBUG_EXTRA_ARGS}
run_cmake_build

cp_log
create_module