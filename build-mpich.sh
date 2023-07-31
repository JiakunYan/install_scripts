#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=mpich
setup_env "$@"

if [[ ${GIS_PACKAGE_NAME_MINOR_EXTRA} == *"embedded"* ]]; then
  CONFIG_EXTRA_ARGS+=" --with-ucx=embedded"
else
  export GIS_PACKAGE_DEPS=("ucx")
fi
load_module

export GIS_DOWNLOAD_URL="https://www.mpich.org/static/downloads/${GIS_PACKAGE_VERSION}/mpich-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  CONFIG_EXTRA_ARGS+=" --enable-g=dbg --enable-fast=O0"
fi
if [[ ${GIS_PACKAGE_NAME_MINOR_EXTRA} == *"global"* ]]; then
  CONFIG_EXTRA_ARGS+=" --enable-thread-cs=global"
fi
run_configure --disable-fortran --disable-romio --with-device=ch4:ucx ${CONFIG_EXTRA_ARGS}
run_make

cp_log
export GIS_MODULE_EXTRA_LINES="
setenv MPI_ROOT      \$root
"
create_module

run_test mpirun
