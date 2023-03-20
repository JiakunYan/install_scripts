#!/usr/bin/env bash

export GIS_INSTALL_ROOT=~/opt

export GIS_PRELOAD_PACKAGES="gcc/11.2.0 shared slurm/slurm/19.05.7"

GIS_DEFAULT_PACKAGE_ARRAY=(
    "cmake/3.24.2" # Provided by Ookami
    "ninja/NULL" # Installed in a default location
    "jemalloc/5.3.0"
    "boost/1.71.0" # Provided by Ookami
    "hwloc/2.8.0" # Provided by Ookami
    "openmpi/gcc11.2/4.1.2" # Provided by Ookami
    "mpich/4.0.2"
    "Vc/1.4.3"
    "papi/6.0.0" # Provided by Ookami
    "hdf5/1.10.1" # Provided by Ookami
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
export CFLAGS="-mcpu=a64fx"
export CXXFLAGS="-mcpu=a64fx"
