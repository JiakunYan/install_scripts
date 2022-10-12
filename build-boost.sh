#!/usr/bin/env bash

source include/common.sh

: ${GCC_VERSION:?}
export PACKAGE_DEPS=("gcc/${GCC_VERSION}")
export PACKAGE_NAME=boost
setup_env

export DOWNLOAD_URL="https://boostorg.jfrog.io/artifactory/main/release/${PACKAGE_VERSION}/source/boost_${PACKAGE_VERSION//./_}.tar.gz"
wget_url

if [[ -d "/etc/opt/cray/release/" ]]; then
	flag1="cxxflags=$CXXFLAGS"
  flag2="threading=multi link=shared"
else
	flag1=""
	flag2=""
fi
(
    mkdir -p ${DIR_BUILD}
    cd ${DIR_SRC} || exit 1
    ./bootstrap.sh --prefix=${DIR_INSTALL} --with-toolset=gcc | tee ${DIR_BUILD}/bootstrap.log 2>&1
    ./b2 -j${PARALLEL_BUILD} "${flag1}" ${flag2} ${BUILD_TYPE} install | tee ${DIR_BUILD}/b2.log 2>&1
)

cp_log
create_module
