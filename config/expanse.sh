#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="DefaultModules"

GIS_DEFAULT_PACKAGES=(
    "gcc/10.2.0"
    "cmake/3.23.4-release"
    "ninja/1.11.1-release"
    "jemalloc/5.3.0-release"
    "libfabric/1.15.1-release"
    "boost/1.80.0-release"
    "hwloc/2.7.1-release"
    "openmpi/4.1.4-release"
    "Vc/1.4.3-release"
    "papi/6.0.0.1"
    "hdf5/1.10.7"
    "silo/4.11-release"
    "lci/local-release"
    "hpx/local-release"
    "cppuddle/master-release"
    "octotiger/master-release"
)
for package in "${GIS_DEFAULT_PACKAGES[@]}"
do
  major=${package%/*}
  minor=${package#*/}
  echo "export GIS_${major}_DEFAULT_VERSION=${minor}"
  export GIS_${major}_DEFAULT_VERSION=${minor}
  unset major
  unset minor
done
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx

export GIS_ENABLE_HPX_OFI=OFF
export GIS_PARALLEL_BUILD=16
export GIS_COMM_BACKEND=ibv