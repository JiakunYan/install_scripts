#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="DefaultModules gcc/10.2.0"

GIS_DEFAULT_PACKAGE_ARRAY=(
    "cmake/3.23.4"
    "ninja/1.11.1"
    "jemalloc/5.3.0"
    "libfabric/1.15.1"
    "boost/1.80.0"
    "hwloc/2.9.1"
    "openmpi/4.1.5"
    "mpich/4.0.2"
    "Vc/1.4.3"
    "papi/7.0.0"
    "hdf5/1.8.12" # Provided by Expanse
    "silo/4.11"
    "lci/local"
    "hpx/local"
    "cppuddle/master"
    "octotiger/local"
    "ucx/1.14.0"
)
export GIS_DEFAULT_PACKAGES="${GIS_DEFAULT_PACKAGE_ARRAY[*]}"
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx
export GIS_LIBIBVERBS_LOCAL_SRC_PATH=~/workspace/rdma-core
export GIS_OCTOTIGER_LOCAL_SRC_PATH=~/workspace/octotiger

export GIS_PARALLEL_BUILD=16
export GIS_COMM_BACKEND=ibv
export GIS_WITH_CUDA=OFF
export GIS_MPI="openmpi"
export CC=gcc
export CXX=g++
export CFLAGS="-fPIC -march=native"
export CXXFLAGS="-fPIC -march=native"
