#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("hpx" "kokkos")
export GIS_PACKAGE_NAME_MAJOR=hpx-kokkos
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/STEllAR-GROUP/hpx-kokkos.git"
if [ "$(get_platform_name)" == "ookami" ] && [ "${GIS_PACKAGE_VERSION}" == "20a44967c742f5a7670b4dff9658d9973bf849f2" ]; then
  if [[ ! -d ${GIS_SRC_PATH} ]]; then
      mkdir -p ${GIS_SRC_PATH}
      cd ${GIS_SRC_PATH} || exit
      git clone ${GIS_DOWNLOAD_URL} ${GIS_SRC_PATH}
      git checkout ${GIS_PACKAGE_VERSION}
      echo "Apply patch to HPX-Kokkos"
      git apply ${GIS_ROOT}/patch/ookami-hpx-kokkos.patch
  fi
else
  wget_url
fi

run_cmake_configure \
        -DHPX_KOKKOS_CUDA_FUTURE_TYPE=event \
        ${CONFIG_EXTRA_ARGS}

run_cmake_build
run_cmake_install

cp_log
create_module

