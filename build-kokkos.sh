#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("hpx")
export GIS_PACKAGE_NAME_MAJOR=kokkos
setup_env "$@"
load_module

export GIS_DOWNLOAD_URL="https://github.com/kokkos/kokkos.git"

if [ "$(get_platform_name)" == "ookami" ] && [ "${GIS_PACKAGE_VERSION}" == "2640cf70de338618a7e4fe10590b06bc1c239f4c" ]; then
  if [[ ! -d ${GIS_SRC_PATH} ]]; then
      mkdir -p ${GIS_SRC_PATH}
      cd ${GIS_SRC_PATH} || exit
      git clone ${GIS_DOWNLOAD_URL} ${GIS_SRC_PATH}
      git checkout ${GIS_PACKAGE_VERSION}
      echo "Apply patch to Kokkos"
      git apply ${GIS_ROOT}/patch/ookami-kokkos-2640cf.patch
  fi
  CONFIG_EXTRA_ARGS="-DKokkos_CXX_STANDARD=17 \
    -DKokkos_ARCH_A64FX=ON"
else
  wget_url
fi

run_cmake_configure \
      	-DKokkos_ENABLE_TESTS=OFF \
      	-DCMAKE_CXX_STANDARD=17 \
      	-DKokkos_ENABLE_INTERNAL_FENCES=OFF \
       	-DKokkos_ENABLE_CUDA=${GIS_WITH_CUDA} \
      	-DKokkos_ENABLE_CUDA_LAMBDA=${GIS_WITH_CUDA} \
      	-DKokkos_ENABLE_CUDA_CONSTEXPR=${GIS_WITH_CUDA} \
       	-DKokkos_ENABLE_SERIAL=ON \
       	-DKokkos_ENABLE_HPX=ON \
        -DKokkos_ENABLE_HPX_ASYNC_DISPATCH=OFF \
       	-DKokkos_COMPILE_LAUNCHER=OFF \
        ${CONFIG_EXTRA_ARGS}

run_cmake_build
run_cmake_install

cp_log
create_module

