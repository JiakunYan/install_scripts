#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="gcc/10.3.1"

GIS_DEFAULT_PACKAGES=(
    "cmake/3.23.2"
    "ninja/1.11.1"
    "jemalloc/5.3.0"
    "libfabric/1.15.1"
    "boost/1.75.0-release"
    "hwloc/2.7.1"
    "openmpi/4.1.4"
    "mpich/4.0.2"
    "Vc/1.4.3"
    "papi/6.0.0"
    "hdf5/1.10.7"
    "silo/4.11"
    "lci/local"
    "hpx/local"
    "cppuddle/master"
    "octotiger/master"
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
GIS_DEFAULT_PACKAGES_STR="${GIS_DEFAULT_PACKAGES[*]}"
export GIS_DEFAULT_PACKAGES_STR
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx-lci-pool

export GIS_PARALLEL_BUILD=16
export GIS_COMM_BACKEND=ibv
export GIS_WITH_CUDA=OFF
export GIS_MPI="openmpi"
