set -o pipefail
set -ex

setup_env() {
  : ${INSTALL_ROOT:?} ${PACKAGE_VERSION:?} ${BUILD_TYPE:?} \
   ${PACKAGE_NAME:?}

  if [ "${PACKAGE_VERSION}" == "local" ] && [ "${DIR_SRC}" == "" ]; then
      DIR_SRC_PTR=${PACKAGE_NAME^^}_DIR_SRC
      : ${!DIR_SRC_PTR:?}
      DIR_SRC=${!DIR_SRC_PTR}
  fi

  SCRIPT_ROOT=$(realpath ".")
  INSTALL_ROOT=$(realpath "${INSTALL_ROOT}")
  MODULE_ROOT=$(realpath "${MODULE_ROOT:-${INSTALL_ROOT}/modulefiles}")
  DIR_SRC=$(realpath "${DIR_SRC:-source/${PACKAGE_NAME}}")

  PACKAGE_NAME_SUFFIX=${PACKAGE_VERSION}-${BUILD_TYPE}
  DIR_INSTALL=${INSTALL_ROOT}/${PACKAGE_NAME}/${PACKAGE_NAME_SUFFIX}
  DIR_BUILD=${DIR_INSTALL}/build
  FILE_MODULE=${MODULE_ROOT}/${PACKAGE_NAME}/${PACKAGE_NAME_SUFFIX}

  export SCRIPT_ROOT DIR_SRC DIR_BUILD DIR_INSTALL FILE_MODULE PACKAGE_NAME_SUFFIX

  module purge
  if [ "$PACKAGE_DEPS" != "" ]; then
    for dep in "${PACKAGE_DEPS[@]}"; do
      module load $dep
    done
  fi
}

wget_url() {
  : ${DOWNLOAD_URL:?}
  if [[ ! -d ${DIR_SRC} ]]; then
      mkdir -p ${DIR_SRC}
      cd ${DIR_SRC}
      case ${DOWNLOAD_URL} in
        *.gz) wget -O- ${DOWNLOAD_URL} | tar xz --strip-components=1;;
        *.bz2) wget -O- ${DOWNLOAD_URL} | tar xj --strip-components=1;;
        *.git) git git clone --branch=${PACKAGE_VERSION} --depth=1 ${DOWNLOAD_URL} ${DIR_SRC}
      esac
  fi
}

run_cmake_configure() {
  CMAKE_BASIC_ARGS="
    -H${DIR_SRC} \
    -B${DIR_BUILD} \
    -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL} \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_CXX_COMPILER=${CXX} \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE}
    -DCMAKE_VERBOSE_MAKEFILE=ON"
  cmake ${CMAKE_BASIC_ARGS} ${CMAKE_EXTRA_ARGS} "$@" | tee ${DIR_BUILD}/configure.log 2>&1
}

run_cmake_build() {
  cmake --build ${DIR_BUILD} --target install -- -j${PARALLEL_BUILD} | tee ${DIR_BUILD}/build.log 2>&1
}

cp_log() {
  mkdir -p ${DIR_INSTALL}/log
  env > ${DIR_INSTALL}/log/env.log
  module list > ${DIR_INSTALL}/log/module.log
  cp ${SCRIPT_ROOT}/build-${PACKAGE_NAME}.sh ${DIR_INSTALL}/log
  cp -r ${SCRIPT_ROOT}/include ${DIR_INSTALL}/log
  cp -r ${SCRIPT_ROOT}/config ${DIR_INSTALL}/log
  if compgen -G "${DIR_BUILD}/*.log" > /dev/null; then
    cp ${DIR_BUILD}/*.log ${DIR_INSTALL}/log
  fi
  if [ -f ${DIR_BUILD}/compile_commands.json ]; then
    cp ${DIR_BUILD}/compile_commands.json ${DIR_INSTALL}/log
  fi
}

run_configure() {
  DIR_CONFIGURE=${DIR_CONFIGURE:-${DIR_SRC}}
  mkdir -p ${DIR_BUILD}
  cd ${DIR_BUILD} || exit 1
  if [ $BUILD_TYPE == "debug" ]; then
     CC=${CC} CXX=${CXX} CPPFLAGS=-DDEBUG CFLAGS="-g -O0" ${DIR_CONFIGURE}/configure --prefix=${DIR_INSTALL} --enable-debug \
                          ${AT_EXTRA_ARGS} | tee ${DIR_BUILD}/configure.log 2>&1
  elif [ $BUILD_TYPE == "release" ]; then
     CC=${CC} CXX=${CXX} CPPFLAGS=-DNDEBUG CFLAGS="-O3" ${DIR_CONFIGURE}/configure --prefix=${DIR_INSTALL} \
                          ${CONFIGURE_EXTRA_ARGS} "$@" | tee ${DIR_BUILD}/configure.log 2>&1
  else
    echo "Unrecognized BUILD_TYPE: ${BUILD_TYPE}!"
    exit 1
  fi
}

run_make() {
  mkdir -p ${DIR_BUILD}
  cd ${DIR_BUILD} || exit 1
  make -j ${PARALLEL_BUILD} | tee ${DIR_BUILD}/build.log 2>&1
  make -j ${PARALLEL_BUILD} install | tee ${DIR_BUILD}/install.log 2>&1
}

create_module() {
  if [ "${PACKAGE_ENV_NAME}" == "" ]; then
    PACKAGE_ENV_NAME=${PACKAGE_NAME^^}
  fi

  MODULE_DEPS=""
  if [ "$PACKAGE_DEPS" != "" ]; then
    for dep in "${PACKAGE_DEPS[@]}"; do
      MODULE_DEPS="$MODULE_DEPS
module load $dep
prereq      $dep"
    done
  fi

  mkdir -p "$(dirname ${FILE_MODULE})"

  cat >${FILE_MODULE} <<EOF
#%Module
proc ModulesHelp { } {
  puts stderr {${PACKAGE_NAME}/${PACKAGE_NAME_SUFFIX}}
}
module-whatis {${PACKAGE_NAME}/${PACKAGE_NAME_SUFFIX}}
set root    ${DIR_INSTALL}
conflict    ${PACKAGE_NAME}
${MODULE_DEPS}
prepend-path    CPATH              \$root/include
prepend-path    PATH               \$root/bin
prepend-path    LD_LIBRARY_PATH    \$root/lib
prepend-path    LIBRARY_PATH       \$root/lib
prepend-path    MANPATH            \$root/share/man
prepend-path    PKG_CONFIG_PATH    \$root/lib/pkgconfig
setenv ${PACKAGE_ENV_NAME}_ROOT        \$root
setenv ${PACKAGE_ENV_NAME}_DIR         \$root
setenv ${PACKAGE_ENV_NAME}_VERSION     ${PACKAGE_NAME_SUFFIX}
${MODULE_EXTRA_LINES}
EOF
}

run_test() {
  module purge
  module load ${PACKAGE_NAME}/${PACKAGE_NAME_SUFFIX}
  which $1
  $1 --version
}