#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake" "hdf5")
export GIS_PACKAGE_NAME_MAJOR=silo
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/LLNL/Silo/releases/download/v${GIS_PACKAGE_VERSION}/silo-${GIS_PACKAGE_VERSION}-bsd.tar.gz"
wget_url

if [ ${GIS_BUILD_TYPE} == "release" ]; then
  RELEASE_EXTRA_ARGS="--enable-optimization"
fi
sed -i 's/-lhdf5/$hdf5_lib\/libhdf5.a -ldl/g' ${GIS_SRC_PATH}/configure
if [ "$(get_platform_name)" == "expanse" ] && [ "${GIS_hdf5_DEFAULT_VERSION}" == "1.10.7" ]; then
  HDF5_ROOT=$HDF5HOME
fi
#HDF5_ROOT=/opt/cray/pe/hdf5/1.12.1.5/gnu/9.1/
#HDF5_ROOT=/global/u1/j/jackyan/opt/hdf5/1.8.12-release
#HDF5_ROOT=/pscratch/sd/j/jackyan/OctoTigerBuildChain/build/hdf5
run_configure --with-hdf5=${HDF5_ROOT}/include,${HDF5_ROOT}/lib ${RELEASE_EXTRA_ARGS}
sed -i.bak -e '866d;867d' ${GIS_BUILD_PATH}/src/silo/Makefile
run_make

cp_log
create_module

run_test browser

