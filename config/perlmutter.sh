#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="craype-x86-milan craype-network-ofi xpmem PrgEnv-gnu gpu"

GIS_DEFAULT_PACKAGES=(
    "gcc/11.2.0"
    "cmake/3.22.0"
    "ninja/1.11.1-release"
    "jemalloc/5.3.0-release"
    "boost/1.78.0-gnu"
    "hwloc/2.7.1-release"
    "Vc/1.4.3-release"
    "openmpi/4.1.4-release"
    "papi/6.0.0.15"
    "hdf5/1.8.12-release"
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

export GIS_PARALLEL_BUILD=16
export GIS_COMM_BACKEND=ofi
export GIS_WITH_CUDA=ON

export CC=gcc
export CXX=g++
