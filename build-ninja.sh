#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=ninja
setup_env

export GIS_DOWNLOAD_URL="https://github.com/ninja-build/ninja/releases/download/v${GIS_PACKAGE_VERSION}/ninja-linux.zip"
mkdir -p ${GIS_SRC_PATH}
cd ${GIS_SRC_PATH} || exit 1
wget "$DOWNLOAD_URL" -O temp.zip
unzip temp.zip
rm -r temp.zip

mkdir -p ${GIS_INSTALL_PATH}/bin
cp ${GIS_SRC_PATH}/ninja ${GIS_INSTALL_PATH}/bin/

cp_log
create_module

run_test ninja