#!/usr/bin/env bash

source include/common.sh

export PACKAGE_NAME=ninja
setup_env

export DOWNLOAD_URL="https://github.com/ninja-build/ninja/releases/download/v${PACKAGE_VERSION}/ninja-linux.zip"
mkdir -p ${DIR_SRC}
cd ${DIR_SRC} || exit 1
wget "$DOWNLOAD_URL" -O temp.zip
unzip temp.zip
rm -r temp.zip

mkdir -p ${DIR_INSTALL}/bin
cp ${DIR_SRC}/ninja ${DIR_INSTALL}/bin/

cp_log
create_module

run_test ninja