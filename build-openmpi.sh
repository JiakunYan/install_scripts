#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}")
export PACKAGE_NAME=openmpi
setup_env "$@"

export DOWNLOAD_URL="https://download.open-mpi.org/release/open-mpi/v${PACKAGE_VERSION::-2}/openmpi-${PACKAGE_VERSION}.tar.gz"
wget_url

unset HWLOC_VERSION
run_configure
run_make

cp_log
export MODULE_EXTRA_LINES="
setenv MPI_ROOT      \$root
"
create_module

run_test mpirun
