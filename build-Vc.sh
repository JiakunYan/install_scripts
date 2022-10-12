#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?} ${CMAKE_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}" "cmake/${CMAKE_VERSION}")
export PACKAGE_NAME=Vc
setup_env

export DOWNLOAD_URL="https://github.com/VcDevel/Vc/releases/download/${PACKAGE_VERSION}/Vc-${PACKAGE_VERSION}.tar.gz"
wget_url

run_cmake_configure
run_cmake_build
cp_log

export PACKAGE_ENV_NAME="Vc"
create_module