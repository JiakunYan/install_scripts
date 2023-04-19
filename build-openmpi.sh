#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("hwloc" "ucx")
export GIS_PACKAGE_NAME_MAJOR=openmpi
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://download.open-mpi.org/release/open-mpi/v${GIS_PACKAGE_VERSION::-2}/openmpi-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

unset HWLOC_VERSION
run_configure --with-ucx
run_make

cp_log
export GIS_MODULE_EXTRA_LINES="
setenv MPI_ROOT      \$root
"
create_module

run_test mpirun
