#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("cmake" "ninja" "boost" "hwloc" "${GIS_MPI}" "jemalloc" "Vc" "papi" "lci")
if [ "$(get_platform_name)" == "perlmutter" ]; then
  GIS_PACKAGE_DEPS+=("libfabric")
fi
export GIS_PACKAGE_NAME_MAJOR=hpx
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/uiuc-hpc/hpx.git"
wget_url

if [[ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" == *"pcounter"* ]]; then
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
  -DHPX_WITH_PARCELPORT_COUNTERS=ON \
  -DHPX_WITH_THREAD_IDLE_RATES=ON \
  -DHPX_WITH_PAPI=ON"
fi
HPX_WITH_EXAMPLES=OFF
if [[ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" == *"example"* ]]; then
  HPX_WITH_EXAMPLES=ON
fi
if [ "$(get_platform_name)" == "ookami" ]; then
  CONFIG_EXTRA_ARGS="${CONFIG_EXTRA_ARGS} \
  -DHPX_WITH_CXX_STANDARD=20 \
  -DHPX_WITH_GENERIC_CONTEXT_COROUTINES=ON \
  -DHPX_WITH_DATAPAR_BACKEND=STD_EXPERIMENTAL_SIMD"
  BOOST_ROOT=$(echo "$CPATH" | tr ':' '\n' | grep boost)/..
  export BOOST_ROOT
fi

run_cmake_configure \
    -GNinja \
    -DHPX_WITH_COMPILER_WARNINGS=ON \
    -DHPX_WITH_COMPILER_WARNINGS_AS_ERRORS=ON \
    -DHPX_WITH_FETCH_ASIO=ON\
    -DHPX_WITH_DISABLED_SIGNAL_EXCEPTION_HANDLERS=ON \
    -DHPX_WITH_MALLOC=JEMALLOC \
    -DHPX_WITH_MAX_CPU_COUNT=256 \
    -DHPX_WITH_EXAMPLES=${HPX_WITH_EXAMPLES} \
    -DHPX_WITH_TESTS=OFF \
    -DHPX_WITH_NETWORKING=ON \
    -DHPX_WITH_PARCELPORT_MPI=ON \
    -DHPX_WITH_PARCELPORT_LCI=ON \
    -DHPX_WITH_ZERO_COPY_SERIALIZATION_THRESHOLD=8192 \
    -DHPX_WITH_CUDA=${GIS_WITH_CUDA} \
    -DAPEX_WITH_ACTIVEHARMONY=FALSE \
    -DAPEX_WITH_MPI=ON \
    ${CONFIG_EXTRA_ARGS}

run_cmake_build
run_cmake_install

cp_log
create_module

run_test hpxrun.py

