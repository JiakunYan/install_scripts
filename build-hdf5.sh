#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake")
export GIS_PACKAGE_NAME_MAJOR=hdf5
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${GIS_PACKAGE_VERSION//./_}.tar.gz"
wget_url

if  [[ -d "/etc/opt/cray/release/" ]]; then
    CONFIG_EXTRA_ARGS="-DALLOW_UNSUPPORTED=ON \
                      -DHDF5_ENABLE_PARALLEL:BOOL=ON \
                      -DHDF5_BUILD_CPP_LIB:BOOL=OFF "
fi
if [ "$(get_platform_name)" == "perlmutter" ]; then
    export MPI_HOME=${MPICH_DIR}
fi
run_cmake_configure ${CONFIG_EXTRA_ARGS}
run_cmake_build
run_cmake_install

cp_log
create_module