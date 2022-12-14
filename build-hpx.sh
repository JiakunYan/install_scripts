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

HPX_WITH_PARCELPORT_LIBFABRIC=OFF
if [ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" == "pcounter" ]; then
  CONFIG_EXTRA_ARGS="-DHPX_WITH_PARCELPORT_COUNTERS=ON"
fi
HPX_WITH_EXAMPLES=OFF
if [ "${GIS_PACKAGE_NAME_MINOR_EXTRA}" == "example" ]; then
  HPX_WITH_EXAMPLES=ON
fi
run_cmake_configure \
    -GNinja \
    -DHPX_WITH_FETCH_ASIO=ON\
    -DHPX_WITH_PAPI=ON \
    -DHPX_WITH_THREAD_IDLE_RATES=ON \
    -DHPX_WITH_DISABLED_SIGNAL_EXCEPTION_HANDLERS=ON \
    -DHPX_WITH_MALLOC=JEMALLOC \
    -DHPX_WITH_NETWORKING=ON \
    -DHPX_WITH_MAX_CPU_COUNT=256 \
    -DHPX_WITH_EXAMPLES=${HPX_WITH_EXAMPLES} \
    -DHPX_WITH_TESTS=OFF \
    -DHPX_WITH_PARCELPORT_MPI=ON \
    -DHPX_WITH_CUDA=${GIS_WITH_CUDA} \
    -DHPX_WITH_CUDA_CLANG=OFF \
    -DHPX_WITH_PARCELPORT_LIBFABRIC=${HPX_WITH_PARCELPORT_LIBFABRIC} \
    -DHPX_PARCELPORT_LIBFABRIC_PROVIDER=${HPX_PARCELPORT_LIBFABRIC_PROVIDER} \
    -DHPX_PARCELPORT_LIBFABRIC_64K_PAGES:STRING=20 \
    -DHPX_PARCELPORT_LIBFABRIC_DEBUG_LOCKS:BOOL=OFF \
    -DHPX_PARCELPORT_LIBFABRIC_ENDPOINT:STRING=rdm \
    -DHPX_PARCELPORT_LIBFABRIC_MAX_PREPOSTS:STRING=512 \
    -DHPX_PARCELPORT_LIBFABRIC_MAX_SENDS:STRING=128 \
    -DHPX_PARCELPORT_LIBFABRIC_MEMORY_CHUNK_SIZE:STRING=4096 \
    -DHPX_PARCELPORT_LIBFABRIC_MEMORY_COPY_THRESHOLD:STRING=4096 \
    -DHPX_PARCELPORT_LIBFABRIC_WITH_DEV_MODE:BOOL=OFF \
    -DHPX_PARCELPORT_LIBFABRIC_WITH_LOGGING:BOOL=OFF \
    -DHPX_PARCELPORT_LIBFABRIC_WITH_PERFORMANCE_COUNTERS:BOOL=OFF \
    -DAPEX_WITH_ACTIVEHARMONY=FALSE \
    -DAPEX_WITH_MPI=ON \
    -DHPX_WITH_PARCELPORT_LCI=ON \
    -DLCI_USE_DREG=OFF \
    -DHPX_WITH_ZERO_COPY_SERIALIZATION_THRESHOLD=4096 \
    ${CONFIG_EXTRA_ARGS}

run_cmake_build
run_cmake_install

cp_log
create_module

run_test hpxrun.py

