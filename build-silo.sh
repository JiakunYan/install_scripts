#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?} ${CMAKE_VERSION:?} ${HDF5_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}" "cmake/${CMAKE_VERSION}" "hdf5/${HDF5_VERSION}")
export PACKAGE_NAME=silo
setup_env

export DOWNLOAD_URL="https://github.com/LLNL/Silo/releases/download/v${PACKAGE_VERSION}/silo-${PACKAGE_VERSION}-bsd.tar.gz"
wget_url

sed -i 's/-lhdf5/$hdf5_lib\/libhdf5.a -ldl/g' ${DIR_SRC}/configure
export CONFIGURE_EXTRA_ARGS="--with-hdf5"
run_configure
sed -i.bak -e '866d;867d' ${DIR_BUILD}/src/silo/Makefile
run_make

cp_log
create_module

run_test browser

