#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("gcc")
export GIS_PACKAGE_NAME_MAJOR=ucx
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/openucx/ucx/releases/download/v${GIS_PACKAGE_VERSION}/ucx-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

export GIS_CONFIGURE_PATH=${GIS_SRC_PATH}/contrib
if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  export GIS_CONFIGURE_EXE=configure-devel
elif [ ${GIS_BUILD_TYPE} == "release" ]; then
  export GIS_CONFIGURE_EXE=configure-release
fi
run_configure
run_make

cp_log
create_module