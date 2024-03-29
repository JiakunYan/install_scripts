#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake" "Vc" "silo")
export GIS_PACKAGE_NAME_MAJOR=octotiger
setup_env "$@"
if [[ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" == *"kokkos"* ]]; then
  echo "Build Octo-Tiger with Kokkos"
  GIS_PACKAGE_DEPS+=("kokkos" "hpx-kokkos")
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
    -DOCTOTIGER_WITH_CXX20=ON \
    -DOCTOTIGER_WITH_KOKKOS=ON
    -DOCTOTIGER_KOKKOS_SIMD_LIBRARY=STD \
    -DOCTOTIGER_KOKKOS_SIMD_EXTENSION=SVE"
fi

hpx_to_load="hpx"
cppuddle_to_load="cppuddle"
if [ "${GIS_BUILD_TYPE}" == "debug" ]; then
  hpx_to_load="hpx/local-debug"
  cppuddle_to_load="cppuddle/master-debug"
fi
if [[ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" == *"apex"* ]]; then
  echo "Build Octo-Tiger with HPX APEX"
  hpx_to_load="hpx/local-release-apex"
fi
GIS_PACKAGE_DEPS+=("${hpx_to_load}" "${cppuddle_to_load}")

# Use a regular expression to find the integer following "griddim"
regex='griddim([0-9]+)'
if [[ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" =~ $regex ]]; then
  griddim=${BASH_REMATCH[1]}
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
      -DOCTOTIGER_WITH_GRIDDIM=${griddim} \
      -DOCTOTIGER_WITH_TESTS=OFF"

  if [ "${griddim}" == "4" ]; then
    CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
        -DOCTOTIGER_THETA_MINIMUM=0.51"
  elif [ "${griddim}" == "3" ]; then
    CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
        -DOCTOTIGER_THETA_MINIMUM=0.51"
  elif [ "${griddim}" == "2" ]; then
    CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
        -DOCTOTIGER_THETA_MINIMUM=1.01"
  elif [ "${griddim}" == "1" ]; then
    CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
        -DOCTOTIGER_THETA_MINIMUM=1.01"
  fi
fi

load_module

export GIS_DOWNLOAD_URL="https://github.com/STEllAR-GROUP/octotiger.git"
wget_url
if [ "$(get_platform_name)" == "ookami" ] && [ "${GIS_PACKAGE_VERSION}" == "reconstruct_simd_optimization" ]; then
  if [[ ! -d ${GIS_SRC_PATH} ]]; then
    cd ${GIS_SRC_PATH} || exit
    echo "Apply patch to Octo-Tiger"
    git apply ${GIS_ROOT}/patch/ookami-octotiger.patch
  fi
fi

OCTOTIGER_ARCH_FLAG="-march=native"
if [ "$(get_platform_name)" == "ookami" ]; then
  export CFLAGS="${CFLAGS} -msve-vector-bits=512"
  export CXXFLAGS="${CFLAGS} -msve-vector-bits=512"
  OCTOTIGER_ARCH_FLAG="-mcpu=a64fx -msve-vector-bits=512"
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
    -DOCTOTIGER_WITH_BLAST_TEST=OFF"
fi

run_cmake_configure \
    -DOCTOTIGER_WITH_BLAST_TEST=ON \
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
    -DOCTOTIGER_ARCH_FLAG="${OCTOTIGER_ARCH_FLAG}" \
    -DSilo_DIR=$SILO_ROOT \
    -DOCTOTIGER_WITH_TESTS=OFF \
    ${CONFIG_EXTRA_ARGS}

run_cmake_build
run_cmake_install
cp_log

create_module

#run_test octotiger