#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export PACKAGE_DEPS=(
        "gcc/${GCC_VERSION}"
    )
export PACKAGE_NAME=papi
setup_env

export DOWNLOAD_URL="http://icl.utk.edu/projects/papi/downloads/papi-${PACKAGE_VERSION}.tar.gz"
wget_url

export DIR_CONFIGURE=${DIR_SRC}/src
export DIR_BUILD=${DIR_SRC}/src
run_configure
run_make

cp_log
create_module