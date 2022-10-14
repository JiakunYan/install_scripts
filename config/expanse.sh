mkdir -p source
#!/usr/bin/env bash
export INSTALL_ROOT=~/opt

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
    "hdf5/1.13.2-release"
    "silo/4.11-release"
    "lci/local-debug"
    "hpx/local-debug"
    "cppuddle/master-release"
    "octotiger/master-debug"
)
for package in "${DEFAULT_MODULES[@]}"
do
  major=${package%/*}
  minor=${package#*/}
  echo "export ${major}_VERSION=${minor}"
  export ${major}_VERSION=${minor}
done
export LCI_DIR_SRC=~/workspace/LC
export HPX_DIR_SRC=~/workspace/hpx

export HAS_PMI=OFF
export PARALLEL_BUILD=4
export LCI_BACKEND=ibv