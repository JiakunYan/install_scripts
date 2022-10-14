#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?} ${CMAKE_VERSION:?} ${HDF5_VERSION:?}
export GIS_PACKAGE_DEPS=("gcc/${GCC_VERSION}" "cmake/${CMAKE_VERSION}" "hdf5/${HDF5_VERSION}")
export GIS_PACKAGE_NAME_MAJOR=silo
setup_env

export GIS_DOWNLOAD_URL="https://github.com/LLNL/Silo/releases/download/v${GIS_PACKAGE_VERSION}/silo-${GIS_PACKAGE_VERSION}-bsd.tar.gz"
wget_url

sed -i 's/-lhdf5/$hdf5_lib\/libhdf5.a -ldl/g' ${GIS_SRC_PATH}/configure
run_configure --with-hdf5=${HDF5_ROOT}/include,${HDF5_ROOT}/lib
sed -i.bak -e '866d;867d' ${GIS_BUILD_PATH}/src/silo/Makefile
run_make

cp_log
create_module

run_test browser

