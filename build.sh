#!/usr/bin/env bash

for package in "$@"
do
    major=${package%/*}
    minor=${package#*/}
    if [ -f ./build-${major}.sh ]; then
      echo "./build-${major}.sh ${minor}"
      ./build-${major}.sh ${minor}
    fi
done