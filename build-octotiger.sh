#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake" "Vc" "hpx" "silo" "cppuddle")
export GIS_PACKAGE_NAME_MAJOR=octotiger
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/JiakunYan/octotiger.git"
wget_url

OCTOTIGER_ARCH_FLAG="-march=native"
if [ "$(get_platform_name)" == "perlmutter" ]; then
  OCTOTIGER_ARCH_FLAG="-mcpu=a64fx"
fi

run_cmake_configure \
    -DOCTOTIGER_WITH_BLAST_TEST=ON \
    -DOCTOTIGER_WITH_TESTS=ON \
    -DOCTOTIGER_WITH_CUDA=${GIS_WITH_CUDA} \
    -DOCTOTIGER_CUDA_ARCH="sm_80" \
    -DCMAKE_CUDA_FLAGS="-arch=sm_80" \
    -DOCTOTIGER_WITH_Vc=ON \
    -DOCTOTIGER_WITH_LEGACY_VC=OFF \
    -DOCTOTIGER_WITH_GRIDDIM=8 \
    -DOCTOTIGER_WITH_MAX_NUMBER_FIELDS=15 \
    -DOCTOTIGER_WITH_MONOPOLE_HOST_HPX_EXECUTOR=OFF \
    -DOCTOTIGER_WITH_MULTIPOLE_HOST_HPX_EXECUTOR=ON \
    -DOCTOTIGER_WITH_FORCE_SCALAR_KOKKOS_SIMD=OFF \
    -DOCTOTIGER_WITH_STD_EXPERIMENTAL_SIMD=OFF \
    -DOCTOTIGER_ARCH_FLAG=${OCTOTIGER_ARCH_FLAG} \
    -DSilo_DIR=$SILO_ROOT
run_cmake_build
run_cmake_install
cp_log

create_module

run_test octotiger