#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="gcc/11.2.0"

GIS_DEFAULT_PACKAGE_ARRAY=(
    "cmake/3.23.1" # Provided by Delta
    "ninja/1.11.1"
    "jemalloc/5.3.0"
    "boost/1.80.0" # Provided by Delta
    "hwloc/2.7.1"
    "Vc/1.4.3"
    "papi/7.0.0"
    "openmpi/4.1.4"
    "hdf5/1.10.7" # Provided by Delta
    "silo/4.11"
    "lci/local"
    "hpx/local"
    "cppuddle/master"
    "octotiger/master"
)
export GIS_DEFAULT_PACKAGES="${GIS_DEFAULT_PACKAGE_ARRAY[*]}"
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx

export GIS_PARALLEL_BUILD=16
export GIS_COMM_BACKEND=ibv
export GIS_WITH_CUDA=OFF

export CC=gcc
export CXX=g++
export GIS_MPI="openmpi"
# Tested with `gcc -march=native -E -v - </dev/null 2>&1`
# Compiling on Perlmutter login node has the same flags as compiling on the compute node.
export CFLAGS="-fPIC -march=native"
export CXXFLAGS="-fPIC -march=native"
# Platform-specific variable.
# Perlmutter needs this in order to run cray-mpich correctly.
#export CRAY_ACCEL_TARGET=nvidia80
#export LINKER_FLAGS="-L/opt/cray/pe/mpich/8.1.24/gtl/lib -lmpi_gtl_cuda"
