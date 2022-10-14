#!/usr/bin/env bash
export GIS_INSTALL_ROOT=~/opt

export GIS_DEFAULT_MODULES=(
    "gcc/9.4.0-release"
    "cmake/3.23.4-release"
    "ninja/1.11.1-release"
    "jemalloc/5.3.0-release"
    "libfabric/1.15.1-release"
    "boost/1.80.0-release"
    "openmpi/4.1.4-release"
    "Vc/1.4.3-release"
    "papi/6.0.0-release"
    "hdf5/1.13.2-release"
    "silo/4.11-release"
    "lci/local-debug"
    "hpx/local-debug"
    "cppuddle/master-release"
    "octotiger/master-debug"
)
for package in "${GIS_DEFAULT_MODULES[@]}"
do
  major=${package%/*}
  minor=${package#*/}
  echo "export ${major}_VERSION=${minor}"
  export GIS_${major}_DEFAULT_VERSION=${minor}
done
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx

export GIS_HAS_PMI=OFF
export GIS_PARALLEL_BUILD=4
export GIS_LCI_BACKEND=ofi