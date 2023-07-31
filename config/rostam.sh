#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="gcc/10.3.1"

GIS_DEFAULT_PACKAGE_ARRAY=(
    "cmake/3.26.3"          # Provided by Rostam
    "ninja/NULL"
    "jemalloc/5.3.0"
    "libfabric/1.15.1"
    "boost/1.75.0-release"
    "hwloc/2.7.1"
    "openmpi/4.1.5"          # Provided by Rostam
    "mpich/4.0.2"
    "Vc/1.4.3"
    "papi/7.0.1"          # Provided by Rostam
    "hdf5/1.10.7"
    "silo/4.11"
    "lci/local"
    "hpx/local"
    "cppuddle/master"
    "octotiger/master"
    "ucx/1.14.0"
)
export GIS_DEFAULT_PACKAGES="${GIS_DEFAULT_PACKAGE_ARRAY[*]}"
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx
export GIS_LIBIBVERBS_LOCAL_SRC_PATH=~/workspace/rdma-core

export GIS_PARALLEL_BUILD=16
export GIS_COMM_BACKEND=ibv
export GIS_WITH_CUDA=OFF
export GIS_MPI="openmpi"
export CFLAGS="-fPIC -march=native"
export CXXFLAGS="-fPIC -march=native"