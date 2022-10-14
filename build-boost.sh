#!/usr/bin/env bash

source include/common.sh

export GIS_PACKAGE_DEPS=("gcc")
export GIS_PACKAGE_NAME_MAJOR=boost
setup_env "$@"

export GIS_DOWNLOAD_URL="https://boostorg.jfrog.io/artifactory/main/release/${GIS_PACKAGE_VERSION}/source/boost_${GIS_PACKAGE_VERSION//./_}.tar.gz"
wget_url

if [[ -d "/etc/opt/cray/release/" ]]; then
	flag1="cxxflags=$CXXFLAGS"
  flag2="threading=multi link=shared"
else
	flag1=""
	flag2=""
fi
(
    mkdir -p ${GIS_BUILD_PATH}
    cd ${GIS_SRC_PATH} || exit 1
    ./bootstrap.sh --prefix=${GIS_INSTALL_PATH} --with-toolset=gcc | tee ${GIS_BUILD_PATH}/bootstrap.log 2>&1
    ./b2 -j${GIS_PARALLEL_BUILD} "${flag1}" ${flag2} ${GIS_BUILD_TYPE} install | tee ${GIS_BUILD_PATH}/b2.log 2>&1
)

cp_log
create_module
