set -o pipefail
set -e

get_platform_name() {
  if [ "${GIS_PLATFORM}" != "" ]; then
    echo ${GIS_PLATFORM}
  elif [ "${CMD_WLM_CLUSTER_NAME}" == "expanse" ]; then
    echo "expanse"
  elif [ "${LMOD_SYSTEM_NAME}" == "perlmutter" ]; then
    echo "perlmutter"
  elif [[ "${HOSTNAME}" =~ "rostam" ]]; then
    echo "rostam"
  else
    echo "pc"
  fi
}

get_dep_default_version() {
  : ${1:?}
  DEP_MAJOR=${1}
  DEP_MINOR_P=GIS_${DEP_MAJOR}_DEFAULT_VERSION
  DEP_MINOR=${!DEP_MINOR_P}
  echo "${DEP_MINOR}"
}

parse_full_dep_names() {
  GIS_PACKAGE_DEPS_FULL_NAME="${GIS_PRELOAD_PACKAGES}"
  if [ "${GIS_PACKAGE_DEPS}" != "" ]; then
    for DEP in "${GIS_PACKAGE_DEPS[@]}"; do
      DEP_MAJOR=${DEP%/*}
      DEP_MINOR=${DEP#*/}
      if [ ${DEP_MINOR} == ${DEP} ]; then
        DEP_MINOR="$(get_dep_default_version "${DEP_MAJOR}")"
      fi
      if [ "${DEP_MINOR}" == "" ]; then
        GIS_PACKAGE_DEPS_FULL_NAME="${GIS_PACKAGE_DEPS_FULL_NAME} ${DEP_MAJOR}"
      else
        GIS_PACKAGE_DEPS_FULL_NAME="${GIS_PACKAGE_DEPS_FULL_NAME} ${DEP_MAJOR}/${DEP_MINOR}"
      fi
    done
  fi
  export GIS_PACKAGE_DEPS_FULL_NAME
}

setup_env() {
  : ${GIS_PACKAGE_NAME_MAJOR:?}
  if test $# -ne 1; then
    GIS_PACKAGE_NAME_MINOR=$(get_dep_default_version "${GIS_PACKAGE_NAME_MAJOR}")
  else
    GIS_PACKAGE_NAME_MINOR=${1}
  fi
  export GIS_PACKAGE_NAME_MINOR

#  GIS_PACKAGE_VERSION=${GIS_PACKAGE_NAME_MINOR%-*}
#  GIS_BUILD_TYPE=${GIS_PACKAGE_NAME_MINOR#*-}
  IFS='-' read -ra MINOR_ARRAY <<< "$GIS_PACKAGE_NAME_MINOR"
  IFS=" "
  GIS_PACKAGE_VERSION=${MINOR_ARRAY[0]}
  if [ "${#MINOR_ARRAY[@]}" -le 1 ]; then
    GIS_BUILD_TYPE=release
  elif [ "${#MINOR_ARRAY[@]}" -le 2 ]; then
    GIS_BUILD_TYPE=${MINOR_ARRAY[1]}
  else
    GIS_BUILD_TYPE=${MINOR_ARRAY[1]}
    MINOR_ARRAY_TEMP=("${MINOR_ARRAY[@]:2}")
    IFS="-" GIS_PACKAGE_NAME_MINOR_EXTRA="${MINOR_ARRAY_TEMP[*]}"
    IFS=" "
  fi
  export GIS_PACKAGE_VERSION GIS_BUILD_TYPE GIS_PACKAGE_NAME_MINOR_EXTRA

  : ${GIS_INSTALL_ROOT:?} ${GIS_PACKAGE_VERSION:?} ${GIS_BUILD_TYPE:?}


  if [ "${GIS_PACKAGE_VERSION}" == "local" ] && [ "${GIS_SRC_PATH}" == "" ]; then
      DIR_SRC_PTR=GIS_${GIS_PACKAGE_NAME_MAJOR^^}_LOCAL_SRC_PATH
      : ${!DIR_SRC_PTR:?}
      GIS_SRC_PATH=${!DIR_SRC_PTR}
  fi

  GIS_SCRIPT_ROOT=$(realpath ".")
  GIS_INSTALL_ROOT=$(realpath "${GIS_INSTALL_ROOT}")
  GIS_MODULE_ROOT=$(realpath "${GIS_MODULE_ROOT:-${GIS_INSTALL_ROOT}/modulefiles}")
  if [ "${GIS_SRC_PATH}" == "" ]; then
    mkdir -p ../install_scripts_source
    GIS_SRC_PATH=$(realpath "../install_scripts_source/${GIS_PACKAGE_NAME_MAJOR}-${GIS_PACKAGE_VERSION}")
  else
    GIS_SRC_PATH=$(realpath "${GIS_SRC_PATH}")
  fi

  GIS_INSTALL_PATH=${GIS_INSTALL_ROOT}/${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}
  if [ "${GIS_BUILD_DIR}" == "" ]; then
    GIS_BUILD_PATH=${GIS_INSTALL_PATH}/build
  else
    GIS_BUILD_PATH=${GIS_BUILD_DIR}/${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}
  fi
  GIS_MODULE_FILE_PATH=${GIS_MODULE_ROOT}/${GIS_PACKAGE_NAME_MAJOR}/${GIS_PACKAGE_NAME_MINOR}

  export GIS_SCRIPT_ROOT GIS_SRC_PATH GIS_BUILD_PATH GIS_INSTALL_PATH GIS_MODULE_FILE_PATH GIS_PACKAGE_NAME_MINOR
  export CFLAGS="${CFLAGS} -fPIC -march=native"
  export CXXFLAGS="${CXXFLAGS} -fPIC -march=native"

  parse_full_dep_names
  module purge
  if [ "${GIS_PACKAGE_DEPS_FULL_NAME}" != "" ]; then
    echo "module load ${GIS_PACKAGE_DEPS_FULL_NAME}"
    module load ${GIS_PACKAGE_DEPS_FULL_NAME}
  fi
  module list
}

wget_url() {
  : ${GIS_DOWNLOAD_URL:?}
  if [[ ! -d ${GIS_SRC_PATH} ]]; then
      mkdir -p ${GIS_SRC_PATH}
      cd ${GIS_SRC_PATH}
      case ${GIS_DOWNLOAD_URL} in
        *.gz) wget -O- ${GIS_DOWNLOAD_URL} | tar xz --strip-components=1;;
        *.tgz) wget -O- ${GIS_DOWNLOAD_URL} | tar xz --strip-components=1;;
        *.bz2) wget -O- ${GIS_DOWNLOAD_URL} | tar xj --strip-components=1;;
        *.git) git clone --branch=${GIS_BRANCH:-${GIS_PACKAGE_VERSION}} --depth=1 ${GIS_DOWNLOAD_URL} ${GIS_SRC_PATH}
               git submodule update --init --recursive ;;
      esac
  fi
}

run_cmake_configure() {
  if [ "${GIS_BUILD_TYPE}" == "debug" ]; then
    GIS_BUILD_TYPE="Debug"
  elif [ "${GIS_BUILD_TYPE}" == "release" ]; then
    GIS_BUILD_TYPE="Release"
  elif [ "${GIS_BUILD_TYPE}" == "relWithDebInfo" ]; then
    GIS_BUILD_TYPE="RelWithDebInfo"
  fi
  mkdir -p ${GIS_BUILD_PATH}
  cmake -H${GIS_SRC_PATH} \
        -B${GIS_BUILD_PATH} \
        -DCMAKE_INSTALL_PREFIX=${GIS_INSTALL_PATH} \
        -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_C_FLAGS="${CFLAGS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS}" \
        -DCMAKE_BUILD_TYPE=${GIS_BUILD_TYPE} \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        ${GIS_CMAKE_EXTRA_ARGS} "$@" | tee ${GIS_BUILD_PATH}/configure.log 2>&1
}

run_cmake_build() {
  cmake --build ${GIS_BUILD_PATH} -- -j${GIS_PARALLEL_BUILD} | tee ${GIS_BUILD_PATH}/build.log 2>&1
}

run_cmake_install() {
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
  GIS_CONFIGURE_EXE=${GIS_CONFIGURE_EXE:-configure}
  if [ ! -f "${GIS_CONFIGURE_PATH}/${GIS_CONFIGURE_EXE}" ]; then
    GIS_AUTOGEN_PATH=${GIS_AUTOGEN_PATH:-${GIS_CONFIGURE_PATH}}
    ${GIS_AUTOGEN_PATH}/autogen.sh
  fi
  mkdir -p ${GIS_BUILD_PATH}
  cd ${GIS_BUILD_PATH} || exit 1
  if [ ${GIS_BUILD_TYPE} == "debug" ]; then
     CC=${CC} CXX=${CXX} CPPFLAGS="${CPPFLAGS} -DDEBUG" CFLAGS="${CFLAGS} -g -O0" CXXFLAGS="${CXXFLAGS} -g -O0" ${GIS_CONFIGURE_PATH}/${GIS_CONFIGURE_EXE} --prefix=${GIS_INSTALL_PATH} --enable-debug \
                          ${GIS_CONFIGURE_EXTRA_ARGS} "$@" | tee ${GIS_BUILD_PATH}/configure.log 2>&1
  elif [ ${GIS_BUILD_TYPE} == "release" ]; then
     CC=${CC} CXX=${CXX} CPPFLAGS="${CPPFLAGS} -DNDEBUG" CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" ${GIS_CONFIGURE_PATH}/${GIS_CONFIGURE_EXE} --prefix=${GIS_INSTALL_PATH} \
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

set_module_default() {
  cat >"$(dirname ${GIS_MODULE_FILE_PATH})"/.version <<EOF
#%Module
set ModulesVersion  "${GIS_PACKAGE_NAME_MINOR}"
EOF
}

create_module() {
  mkdir -p "$(dirname ${GIS_MODULE_FILE_PATH})"

  if [ "${GIS_PACKAGE_NAME_MINOR}" == "$(get_dep_default_version "${GIS_PACKAGE_NAME_MAJOR}")" ]; then
    set_module_default
  fi

  MODULE_DEPS=""
  if [ "${GIS_PACKAGE_DEPS_FULL_NAME}" != "" ]; then
      MODULE_DEPS="$MODULE_DEPS
module load ${GIS_PACKAGE_DEPS_FULL_NAME}"
  fi

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
prepend-path    LD_LIBRARY_PATH    \$root/lib:\$root/lib64
prepend-path    LIBRARY_PATH       \$root/lib:\$root/lib64
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
