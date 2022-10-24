#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("gcc" "cmake" "Vc" "hpx" "silo" "cppuddle")
export GIS_PACKAGE_NAME_MAJOR=octotiger
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/JiakunYan/octotiger.git"
wget_url

run_cmake_configure \
    -DOCTOTIGER_WITH_BLAST_TEST=ON \
    -DOCTOTIGER_WITH_TESTS=ON \
    -DOCTOTIGER_WITH_Vc=ON \
    -DOCTOTIGER_WITH_LEGACY_VC=OFF \
    -DOCTOTIGER_WITH_GRIDDIM=8 \
    -DOCTOTIGER_WITH_MAX_NUMBER_FIELDS=15 \
    -DOCTOTIGER_WITH_MONOPOLE_HOST_HPX_EXECUTOR=OFF \
    -DOCTOTIGER_WITH_MULTIPOLE_HOST_HPX_EXECUTOR=ON \
    -DOCTOTIGER_WITH_FORCE_SCALAR_KOKKOS_SIMD=OFF \
    -DOCTOTIGER_WITH_STD_EXPERIMENTAL_SIMD=OFF \
    -DSilo_INCLUDE_DIR=$SILO_ROOT/include \
    -DSilo_LIBRARY=$SILO_ROOT/lib/libsiloh5.a \
    -DSilo_DIR=$SILO_ROOT \
    -DOCTOTIGER_ARCH_FLAG="-march=native"
run_cmake_build
run_cmake_install
cp_log

create_module

run_test octotiger
