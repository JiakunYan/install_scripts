mkdir -p source
#!/usr/bin/env bash
export GIS_INSTALL_ROOT=~/opt

export DEFAULT_MODULES=(
    "gcc/10.2.0"
    "cmake/3.23.4-release"
    "ninja/1.11.1-release"
    "jemalloc/5.3.0-release"
    "libfabric/1.15.1-release"
    "boost/1.80.0-release"
    "openmpi/4.1.4-release"
    "Vc/1.4.3-release"
    "papi/6.0.0-release"
    "hdf5/1.8.12-release"
    "silo/4.11-release"
    "lci/local-release"
    "hpx/local-release"
    "cppuddle/master-release"
    "octotiger/master-release"
)
for package in "${DEFAULT_MODULES[@]}"
do
  major=${package%/*}
  minor=${package#*/}
  echo "export ${major}_VERSION=${minor}"
  export ${major}_VERSION=${minor}
done
export GIS_LCI_LOCAL_SRC_PATH=~/workspace/LC
export GIS_HPX_LOCAL_SRC_PATH=~/workspace/hpx

export GIS_HAS_PMI=ON
export GIS_PARALLEL_BUILD=16
export GIS_LCI_BACKEND=ibv