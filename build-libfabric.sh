#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("gcc")
export GIS_PACKAGE_NAME_MAJOR=libfabric
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/ofiwg/libfabric/releases/download/v${GIS_PACKAGE_VERSION}/libfabric-${GIS_PACKAGE_VERSION}.tar.bz2"
wget_url

if [ "$(get_platform_name)" == "expanse" ]; then
  OFI_BACKEND="--enable-ibv --disable-opx --disable-sockets --disable-udp --disable-shm --disable-tcp"
fi
run_configure ${OFI_BACKEND}
run_make
cp_log

create_module

run_test fi_info

