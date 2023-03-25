#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake" "hdf5")
export GIS_PACKAGE_NAME_MAJOR=silo
if [ "$(get_platform_name)" == "ookami" ]; then
  # -mcpu=a64fx doesn't work for silo for some reason
  export CFLAGS=""
  export CXXFLAGS=""
fi
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/LLNL/Silo/releases/download/v${GIS_PACKAGE_VERSION}/silo-${GIS_PACKAGE_VERSION}-bsd.tar.gz"
wget_url

if [ ${GIS_BUILD_TYPE} == "release" ]; then
  RELEASE_EXTRA_ARGS="--enable-optimization"
fi
sed -i 's/-lhdf5/$hdf5_lib\/libhdf5.a -ldl/g' ${GIS_SRC_PATH}/configure
if [ "$(get_platform_name)" == "expanse" ] && [ "$(get_dep_minor_default "hdf5")" == "1.10.7" ]; then
  HDF5_ROOT=$HDF5HOME
fi
if [ "$(get_platform_name)" == "ookami" ] && [ "$(get_dep_minor_default "hdf5")" == "1.10.1" ]; then
  HDF5_ROOT=${HDF5DIR}/..
fi
run_configure --with-hdf5=${HDF5_ROOT}/include,${HDF5_ROOT}/lib ${RELEASE_EXTRA_ARGS}
sed -i.bak -e '866d;867d' ${GIS_BUILD_PATH}/src/silo/Makefile
run_make

cp_log
create_module

run_test browser

