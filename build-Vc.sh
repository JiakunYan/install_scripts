#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("gcc" "cmake")
export GIS_PACKAGE_NAME_MAJOR=Vc
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/VcDevel/Vc/releases/download/${GIS_PACKAGE_VERSION}/Vc-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

run_cmake_configure
run_cmake_build
run_cmake_install
cp_log

create_module