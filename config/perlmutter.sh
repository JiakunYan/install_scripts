#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="craype-x86-milan craype-network-ofi xpmem PrgEnv-gnu gpu cray-mpich/8.1.17"

GIS_DEFAULT_PACKAGES=(
    "cmake/3.22.0"
    "ninja/1.11.1"
    "jemalloc/5.3.0"
    "boost/1.80.0"
    "hwloc/2.7.1"
    "Vc/1.4.3"
    "papi/6.0.0.16"
    "hdf5/1.8.12"
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
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx

export GIS_PARALLEL_BUILD=16
export GIS_COMM_BACKEND=ofi
export GIS_WITH_CUDA=ON

export CC=gcc
export CXX=g++
export GIS_MPI="cray-mpich/8.1.22"