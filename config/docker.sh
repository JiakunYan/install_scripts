#!/usr/bin/env bash

export GIS_INSTALL_ROOT=/opt

GIS_DEFAULT_PACKAGE_ARRAY=(
    "cmake/3.23.4"
    "ninja/1.11.1"
    "jemalloc/5.3.0"
    "libfabric/1.15.1"
    "libibverbs/42.0"
    "boost/1.80.0"
    "hwloc/2.7.1"
    "openmpi/4.1.4"
    "mpich/4.0.2"
    "Vc/1.4.3"
    "papi/6.0.0"
    "hdf5/1.8.12"
    "silo/4.11"
    "lci/local-debug"
    "hpx/local-debug"
    "cppuddle/master"
    "octotiger/master-debug"
)
export GIS_DEFAULT_PACKAGES="${GIS_DEFAULT_PACKAGE_ARRAY[*]}"
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx

export GIS_PARALLEL_BUILD=4
export GIS_COMM_BACKEND=ofi
export GIS_WITH_CUDA=OFF

export CC=gcc
export CXX=g++
export GIS_MPI="openmpi"
export CFLAGS="-fPIC -march=native"
export CXXFLAGS="-fPIC -march=native"