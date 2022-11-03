#!/usr/bin/env bash

set -ex

build() {
  for package in "$@"
  do
      major=${package%/*}
      minor=${package#*/}
      if [ ${minor} == ${major} ]; then
        minor=""
      fi
      if [ -f ./build-${major}.sh ]; then
        echo "./build-${major}.sh ${minor}"
        ./build-${major}.sh ${minor}
      fi
  done
}

clean() {
  for package in "$@"
  do
      major=${package%/*}
      minor=${package#*/}
      if [ ${minor} == ${major} ]; then
        minor=""
      fi
      if [ -f ./build-${major}.sh ]; then
        : ${GIS_INSTALL_ROOT:?} ${major:?}
        rm -r ${GIS_INSTALL_ROOT}/modulefiles/${major}/${minor}
        rm -r ${GIS_INSTALL_ROOT}/${major}/${minor}
      fi
  done
}

source include/common.sh
source config/"$(get_platform_name)".sh
"$@"