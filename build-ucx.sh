#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=ucx
setup_env "$@"
load_module

export GIS_BRANCH=v${GIS_PACKAGE_VERSION}
export GIS_DOWNLOAD_URL="https://github.com/openucx/ucx.git"
wget_url

export GO111MODULE=off
export GIS_CONFIGURE_PATH=${GIS_SRC_PATH}/contrib
export GIS_AUTOGEN_PATH=${GIS_SRC_PATH}
if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  export GIS_CONFIGURE_EXE=configure-devel
elif [ ${GIS_BUILD_TYPE} == "release" ]; then
  export GIS_CONFIGURE_EXE=configure-release
fi
if [ ! -f ${GIS_SRC_PATH}/configure ]; then
  cd ${GIS_SRC_PATH} || exit
  ${GIS_SRC_PATH}/autogen.sh
fi
run_configure
run_make

cp_log
create_module