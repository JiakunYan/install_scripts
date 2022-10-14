#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export GIS_PACKAGE_DEPS=(
        "gcc/${GCC_VERSION}"
    )
export GIS_PACKAGE_NAME_MAJOR=papi
setup_env

export GIS_DOWNLOAD_URL="http://icl.utk.edu/projects/papi/downloads/papi-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

export GIS_CONFIGURE_PATH=${GIS_SRC_PATH}/src
export GIS_BUILD_PATH=${GIS_SRC_PATH}/src
run_configure
run_make

cp_log
create_module