#!/usr/bin/env bash

set -e

source include/common.sh
source config/"$(get_platform_name)".sh

build() {
  for package in "$@"
  do
      major="$(get_dep_major "$package")"
      minor="$(get_dep_minor "$package")"
      if [ -f ./build-${major}.sh ]; then
        echo "./build-${major}.sh ${minor}"
        bash ./build-${major}.sh ${minor}
      fi
  done
}

clean() {
  for package in "$@"
  do
      major="$(get_dep_major "$package")"
      minor="$(get_dep_minor "$package")"
      if [ -f ./build-${major}.sh ]; then
        : ${GIS_INSTALL_ROOT:?} ${major:?}
        rm -r ${GIS_INSTALL_ROOT:?}/${major:?}/${minor}
        rm -r ${GIS_INSTALL_ROOT:?}/modulefiles/${major:?}/${minor}
      fi
  done
}

"$@"