#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export GIS_PACKAGE_DEPS=("gcc/${GCC_VERSION}")
export GIS_PACKAGE_NAME_MAJOR=cmake
setup_env

export GIS_DOWNLOAD_URL="https://github.com/Kitware/CMake/releases/download/v${GIS_PACKAGE_VERSION}/cmake-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

run_configure --parallel=${GIS_PARALLEL_BUILD} -- -DCMAKE_BUILD_TYPE=${GIS_BUILD_TYPE} -DCMAKE_USE_OPENSSL=OFF
run_make
cp_log

export GIS_MODULE_EXTRA_LINES="
prepend-path    ACLOCAL_PATH    \$root/share/aclocal
setenv          CMAKE_COMMAND   \$root/bin/cmake
"
create_module

run_test cmake

