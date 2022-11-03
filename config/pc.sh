#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

GIS_DEFAULT_PACKAGES=(
    "cmake/3.23.4-release"
    "ninja/1.11.1-release"
    "jemalloc/5.3.0-release"
    "libfabric/1.15.1-release"
    "boost/1.80.0-release"
    "hwloc/2.7.1-release"
    "openmpi/4.1.4-release"
    "Vc/1.4.3-release"
    "papi/6.0.0-release"
    "hdf5/1.8.12-release"
    "silo/4.11-release"
    "lci/local-debug"
    "hpx/local-debug"
    "cppuddle/master-release"
    "octotiger/master-debug"
)
for package in "${GIS_DEFAULT_PACKAGES[@]}"
do
  major=${package%/*}
  minor=${package#*/}
  echo "export GIS_${major}_DEFAULT_VERSION==${minor}"
  export GIS_${major}_DEFAULT_VERSION=${minor}
  unset major
  unset minor
done
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx

export GIS_PARALLEL_BUILD=4
export GIS_COMM_BACKEND=ofi
export GIS_WITH_CUDA=OFF