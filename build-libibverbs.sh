#!/usr/bin/env bash

# if "No package 'libnl' found", try `sudo apt-get install libnl-3-dev`.
# if "No package 'libnl-route-3.0' found", try `sudo apt-get install libnl-route-3-dev`

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake")
export GIS_PACKAGE_NAME_MAJOR=libibverbs
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/linux-rdma/rdma-core/releases/download/v${GIS_PACKAGE_VERSION}/rdma-core-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

if [ ${GIS_BUILD_TYPE} == "debug" ]; then
  CONFIG_EXTRA_ARGS="-DMLX5_DEBUG=ON"
fi
run_cmake_configure -DENABLE_RESOLVE_NEIGH=OFF -DIN_PLACE=0 -DNO_MAN_PAGES=1 ${CONFIG_EXTRA_ARGS}
run_cmake_build
run_cmake_install
#rm -rf ${GIS_INSTALL_PATH:?}/bin ${GIS_INSTALL_PATH:?}/include ${GIS_INSTALL_PATH:?}/lib
#ln -s ${GIS_BUILD_PATH}/bin ${GIS_INSTALL_PATH}/bin
#ln -s ${GIS_BUILD_PATH}/include ${GIS_INSTALL_PATH}/include
#ln -s ${GIS_BUILD_PATH}/lib ${GIS_INSTALL_PATH}/lib
#ln -s ${GIS_BUILD_PATH}/etc ${GIS_INSTALL_PATH}/etc
cp_log

export GIS_MODULE_EXTRA_LINES="
setenv IBV_ROOT      \$root
"
create_module