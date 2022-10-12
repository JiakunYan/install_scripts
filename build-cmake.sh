#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}")
export PACKAGE_NAME=cmake
setup_env

export DOWNLOAD_URL="https://github.com/Kitware/CMake/releases/download/v${PACKAGE_VERSION}/cmake-${PACKAGE_VERSION}.tar.gz"
wget_url

export CONFIGURE_EXTRA_ARGS="--parallel=${PARALLEL_BUILD} -- -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_USE_OPENSSL=OFF"
run_configure
run_make
cp_log

export MODULE_EXTRA_LINES="
prepend-path    ACLOCAL_PATH    \$root/share/aclocal
setenv          CMAKE_COMMAND   \$root/bin/cmake
"
create_module

run_test cmake

