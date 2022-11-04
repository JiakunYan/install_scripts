#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=mpich
setup_env "$@"

export GIS_DOWNLOAD_URL="https://www.mpich.org/static/downloads/${GIS_PACKAGE_VERSION}/mpich-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

run_configure --disable-fortran
run_make

cp_log
export GIS_MODULE_EXTRA_LINES="
setenv MPI_ROOT      \$root
"
create_module

run_test mpirun
