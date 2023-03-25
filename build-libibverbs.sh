#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake")
export GIS_PACKAGE_NAME_MAJOR=libibverbs
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/linux-rdma/rdma-core/releases/download/v${GIS_PACKAGE_VERSION}/rdma-core-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url


run_cmake_configure
run_cmake_build
rm -rf ${GIS_INSTALL_PATH:?}/bin ${GIS_INSTALL_PATH:?}/include ${GIS_INSTALL_PATH:?}/lib
ln -s ${GIS_BUILD_PATH}/bin ${GIS_INSTALL_PATH}/bin
ln -s ${GIS_BUILD_PATH}/include ${GIS_INSTALL_PATH}/include
ln -s ${GIS_BUILD_PATH}/lib ${GIS_INSTALL_PATH}/lib
cp_log

export GIS_MODULE_EXTRA_LINES="
setenv IBV_ROOT      \$root
"
create_module