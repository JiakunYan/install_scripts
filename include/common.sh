set -o pipefail
set -ex

setup_env() {
  if test $# -eq 1; then
    export GIS_PACKAGE_VERSION=${1%-*}
    export GIS_BUILD_TYPE=${1#*-}
  fi

  : ${GIS_INSTALL_ROOT:?} ${GIS_PACKAGE_VERSION:?} ${GIS_BUILD_TYPE:?} \
   ${GIS_PACKAGE_NAME_MAJOR:?}

  if [ "${GIS_PACKAGE_VERSION}" == "local" ] && [ "${GIS_SRC_PATH}" == "" ]; then
      DIR_SRC_PTR=GIS_${GIS_PACKAGE_NAME_MAJOR^^}_LOCAL_SRC_PATH
      : ${!DIR_SRC_PTR:?}
      GIS_SRC_PATH=${!DIR_SRC_PTR}
  fi

  GIS_SCRIPT_ROOT=$(realpath ".")
  GIS_INSTALL_ROOT=$(realpath "${GIS_INSTALL_ROOT}")
  GIS_MODULE_ROOT=$(realpath "${GIS_MODULE_ROOT:-${GIS_INSTALL_ROOT}/modulefiles}")
  GIS_SRC_PATH=$(realpath "${GIS_SRC_PATH:-source/${GIS_PACKAGE_NAME_MAJOR}}")

  GIS_PACKAGE_NAME_MINOR=${GIS_PACKAGE_VERSION}-${GIS_BUILD_TYPE}
  GIS_INSTALL_PATH=${GIS_INSTALL_ROOT}/${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}
  GIS_BUILD_PATH=${GIS_INSTALL_PATH}/build
  GIS_MODULE_FILE_PATH=${GIS_MODULE_ROOT}/${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}

  export GIS_SCRIPT_ROOT GIS_SRC_PATH GIS_BUILD_PATH GIS_INSTALL_PATH GIS_MODULE_FILE_PATH GIS_PACKAGE_NAME_MINOR

  module purge
  if [ "${GIS_PACKAGE_DEPS}" != "" ]; then
    for DEP in "${GIS_PACKAGE_DEPS[@]}"; do
      DEP_MAJOR=${DEP%/*}
      DEP_MINOR=${DEP#*/}
      if [ ${DEP_MINOR} == ${DEP} ]; then
        DEP_MINOR_P=GIS_${DEP_MINOR}_DEFAULT_VERSION
        DEP_MINOR=${!DEP_MINOR_P}
      fi
      : ${DEP_MINOR:?}
      module load ${DEP_MAJOR}/${DEP_MINOR}
    done
  fi
}

wget_url() {
  : ${GIS_DOWNLOAD_URL:?}
  if [[ ! -d ${GIS_SRC_PATH} ]]; then
      mkdir -p ${GIS_SRC_PATH}
      cd ${GIS_SRC_PATH}
      case ${GIS_DOWNLOAD_URL} in
        *.gz) wget -O- ${GIS_DOWNLOAD_URL} | tar xz --strip-components=1;;
        *.bz2) wget -O- ${GIS_DOWNLOAD_URL} | tar xj --strip-components=1;;
        *.git) git clone --branch=${GIS_PACKAGE_VERSION} --depth=1 ${GIS_DOWNLOAD_URL} ${GIS_SRC_PATH}
               git submodule update --init --recursive ;;
      esac
  fi
}

run_cmake_configure() {
  CMAKE_BASIC_ARGS="
    -H${GIS_SRC_PATH} \
    -B${GIS_BUILD_PATH} \
    -DCMAKE_INSTALL_PREFIX=${GIS_INSTALL_PATH} \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_CXX_COMPILER=${CXX} \
    -DCMAKE_BUILD_TYPE=${GIS_BUILD_TYPE}
    -DCMAKE_VERBOSE_MAKEFILE=ON"
  cmake ${CMAKE_BASIC_ARGS} ${GIS_CMAKE_EXTRA_ARGS} "$@" | tee ${GIS_BUILD_PATH}/configure.log 2>&1
}

run_cmake_build() {
  cmake --build ${GIS_BUILD_PATH} -- -j${GIS_PARALLEL_BUILD} | tee ${GIS_BUILD_PATH}/build.log 2>&1
  cmake --build ${GIS_BUILD_PATH} --target install -- -j${GIS_PARALLEL_BUILD} | tee ${GIS_BUILD_PATH}/install.log 2>&1
}

cp_log() {
  mkdir -p ${GIS_INSTALL_PATH}/log
  env > ${GIS_INSTALL_PATH}/log/env.log
  module list > ${GIS_INSTALL_PATH}/log/module.log
  cp ${GIS_SCRIPT_ROOT}/build-${GIS_PACKAGE_NAME_MAJOR}.sh ${GIS_INSTALL_PATH}/log
  cp -r ${GIS_SCRIPT_ROOT}/include ${GIS_INSTALL_PATH}/log
  cp -r ${GIS_SCRIPT_ROOT}/config ${GIS_INSTALL_PATH}/log
  if compgen -G "${GIS_BUILD_PATH}/*.log" > /dev/null; then
    cp ${GIS_BUILD_PATH}/*.log ${GIS_INSTALL_PATH}/log
  fi
  if [ -f ${GIS_BUILD_PATH}/compile_commands.json ]; then
    cp ${GIS_BUILD_PATH}/compile_commands.json ${GIS_INSTALL_PATH}/log
  fi
}

run_configure() {
  GIS_CONFIGURE_PATH=${GIS_CONFIGURE_PATH:-${GIS_SRC_PATH}}
  mkdir -p ${GIS_BUILD_PATH}
  cd ${GIS_BUILD_PATH} || exit 1
  if [ ${GIS_BUILD_TYPE} == "debug" ]; then
     CC=${CC} CXX=${CXX} CPPFLAGS=-DDEBUG CFLAGS="-g -O0" ${GIS_CONFIGURE_PATH}/configure --prefix=${GIS_INSTALL_PATH} --enable-debug \
                          ${GIS_CONFIGURE_EXTRA_ARGS} "$@" | tee ${GIS_BUILD_PATH}/configure.log 2>&1
  elif [ ${GIS_BUILD_TYPE} == "release" ]; then
     CC=${CC} CXX=${CXX} CPPFLAGS=-DNDEBUG CFLAGS="-O3" ${GIS_CONFIGURE_PATH}/configure --prefix=${GIS_INSTALL_PATH} \
                          ${GIS_CONFIGURE_EXTRA_ARGS} "$@" | tee ${GIS_BUILD_PATH}/configure.log 2>&1
  else
    echo "Unrecognized GIS_BUILD_TYPE: ${GIS_BUILD_TYPE}!"
    exit 1
  fi
}

run_make() {
  mkdir -p ${GIS_BUILD_PATH}
  cd ${GIS_BUILD_PATH} || exit 1
  make -j ${GIS_PARALLEL_BUILD} | tee ${GIS_BUILD_PATH}/build.log 2>&1
  make -j ${GIS_PARALLEL_BUILD} install | tee ${GIS_BUILD_PATH}/install.log 2>&1
}

create_module() {
  MODULE_DEPS=""
  if [ "${GIS_PACKAGE_DEPS}" != "" ]; then
    for dep in "${GIS_PACKAGE_DEPS[@]}"; do
      MODULE_DEPS="$MODULE_DEPS
module load $dep
prereq      $dep"
    done
  fi

  mkdir -p "$(dirname ${GIS_MODULE_FILE_PATH})"

  cat >${GIS_MODULE_FILE_PATH} <<EOF
#%Module
proc ModulesHelp { } {
  puts stderr {${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}}
}
module-whatis {${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}}
set root    ${GIS_INSTALL_PATH}
conflict    ${GIS_PACKAGE_NAME_MAJOR}
${MODULE_DEPS}
prepend-path    CPATH              \$root/include
prepend-path    PATH               \$root/bin
prepend-path    LD_LIBRARY_PATH    \$root/lib
prepend-path    LIBRARY_PATH       \$root/lib
prepend-path    MANPATH            \$root/share/man
prepend-path    PKG_CONFIG_PATH    \$root/lib/pkgconfig
setenv ${GIS_PACKAGE_NAME_MAJOR^^}_ROOT      \$root
setenv ${GIS_PACKAGE_NAME_MAJOR}_ROOT        \$root
setenv ${GIS_PACKAGE_NAME_MAJOR^^}_DIR       \$root
setenv ${GIS_PACKAGE_NAME_MAJOR}_DIR         \$root
setenv ${GIS_PACKAGE_NAME_MAJOR^^}_VERSION   ${GIS_PACKAGE_NAME_MINOR}
setenv ${GIS_PACKAGE_NAME_MAJOR}_VERSION     ${GIS_PACKAGE_NAME_MINOR}
${GIS_MODULE_EXTRA_LINES}
EOF
}

run_test() {
  module purge
  module load ${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}
  which $1
  $1 --version
}