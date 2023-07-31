#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("hwloc" "ucx")
export GIS_PACKAGE_NAME_MAJOR=openmpi
setup_env "$@"
load_module

if [[ ${GIS_PACKAGE_VERSION} == "cont" ]]; then
  GIS_DOWNLOAD_URL=https://github.com/devreal/ompi.git
  export GIS_BRANCH=mpi-continue-master
  CONFIG_EXTRA_ARGS+=" --enable-mpi-ext=continue"
else
  GIS_DOWNLOAD_URL="https://download.open-mpi.org/release/open-mpi/v${GIS_PACKAGE_VERSION::-2}/openmpi-${GIS_PACKAGE_VERSION}.tar.gz"
fi
export GIS_DOWNLOAD_URL

wget_url

unset HWLOC_VERSION
export GIS_AUTOGEN_EXE=autogen.pl
run_configure --with-ucx ${CONFIG_EXTRA_ARGS}

run_make

cp_log
export GIS_MODULE_EXTRA_LINES="
setenv MPI_ROOT      \$root
"
create_module

run_test mpirun
