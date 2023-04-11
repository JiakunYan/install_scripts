#!/usr/bin/env bash

set -x

source include/common.sh

GIS_PACKAGE_DEPS=("cmake" "${GIS_MPI}" "papi")
if [ "${GIS_COMM_BACKEND}" == "ofi" ]; then
  GIS_PACKAGE_DEPS+=("libfabric")
fi
export GIS_PACKAGE_DEPS
export GIS_PACKAGE_NAME_MAJOR=lci
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/uiuc-hpc/LC.git"
wget_url

LCI_USE_PERFORMANCE_COUNTER=OFF
if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  CONFIG_EXTRA_ARGS="-DLCI_DEBUG=ON"
  LCI_USE_PERFORMANCE_COUNTER=ON
fi
if [[ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" == *"pcounter"* ]]; then
  LCI_USE_PERFORMANCE_COUNTER=ON
  echo "Explicitly enable the performance counter"
fi
if [ "$(get_platform_name)" == "ookami" ]; then
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
  -DLCI_OPTIMIZE_FOR_NATIVE=OFF \
  -DLCI_CACHE_SIZE=256"
fi
run_cmake_configure \
    -DLCI_SERVER=${GIS_COMM_BACKEND} \
    -DLCI_USE_PERFORMANCE_COUNTER=${LCI_USE_PERFORMANCE_COUNTER} \
    -DLCI_USE_PAPI=ON \
    ${CONFIG_EXTRA_ARGS}
run_cmake_build
run_cmake_install

cp_log
create_module