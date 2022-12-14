#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("hwloc")
export GIS_PACKAGE_NAME_MAJOR=openmpi
setup_env "$@"

export GIS_DOWNLOAD_URL="https://download.open-mpi.org/release/open-mpi/v${GIS_PACKAGE_VERSION::-2}/openmpi-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

unset HWLOC_VERSION
if [ "$(get_platform_name)" == "expanse" ]; then
  OMPI_OPTION="--with-pmix"
fi
run_configure ${OMPI_OPTION}
run_make

cp_log
export GIS_MODULE_EXTRA_LINES="
setenv MPI_ROOT      \$root
"
create_module

run_test mpirun
