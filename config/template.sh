#!/usr/bin/env bash

# Where to install all the packages
export GIS_INSTALL_ROOT=~/opt
# Default modules to load for all packages
export GIS_PRELOAD_PACKAGES=""
# Default version of all packages
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
    "hdf5/1.8.12"
    "silo/4.11"
    "lci/pawatm23"
    "hpx/pawatm23"
    "cppuddle/master"
    "octotiger/master"
    "ucx/1.14.0"
)
export GIS_DEFAULT_PACKAGES="${GIS_DEFAULT_PACKAGE_ARRAY[*]}"
# The parallelism when building packages
export GIS_PARALLEL_BUILD=16
# The network backend to use (ibv for infiniband, ofi for libfabric) for applied packages
export GIS_COMM_BACKEND=ibv
# Whether to enable GPU build for applied packages
export GIS_WITH_CUDA=OFF
# The MPI vendor to use
export GIS_MPI="openmpi"
# Some common build flags
export CC=gcc
export CXX=g++
export CFLAGS="-fPIC -march=native"
export CXXFLAGS="-fPIC -march=native"

# You also need to modify "get_platform_name" in ../include/common.sh to specify a way to identify your platform
