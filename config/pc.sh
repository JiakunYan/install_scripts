#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

GIS_DEFAULT_PACKAGE_ARRAY=(
    "module/5.2.0"
    "cmake/3.23.4"
    "ninja/1.11.1"
    "jemalloc/5.3.0"
    "libfabric/1.15.1"
    "libibverbs/42.0"
    "boost/1.80.0"
    "hwloc/2.7.1"
    "openmpi/4.1.4"
    "mpich/local-debug"
    "Vc/1.4.3"
    "papi/7.0.0"
    "hdf5/1.8.12"
    "silo/4.11"
    "lci/pawatm23"
    "hpx/pawatm23"
    "cppuddle/master"
    "octotiger/master-debug"
    "pmix/4.2.2"
    "prrte/3.0.0"
    "ucx/1.14.0"
)
export GIS_DEFAULT_PACKAGES="${GIS_DEFAULT_PACKAGE_ARRAY[*]}"
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx
export GIS_MPICH_LOCAL_SRC_PATH=~/workspace/mpich

export GIS_PARALLEL_BUILD=8
export GIS_COMM_BACKEND=ofi
export GIS_WITH_CUDA=OFF

export CC=gcc
export CXX=g++
export GIS_MPI="openmpi"
export CFLAGS="-fPIC -march=native"
export CXXFLAGS="-fPIC -march=native"