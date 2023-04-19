#!/usr/bin/env bash

# If "tclsh could not be found", try "sudo apt install tcl"
# If "autoreconf could not be found", try "sudo apt install autoconf"
# If "Can't find Tcl configuration definitions", try `sudo apt install tcl-dev`

source include/common.sh

export GIS_PACKAGE_NAME_MAJOR=module
setup_env "$@"

export GIS_DOWNLOAD_URL="https://github.com/cea-hpc/modules/releases/download/v${GIS_PACKAGE_VERSION}/modules-${GIS_PACKAGE_VERSION}.tar.gz"
wget_url

export GIS_BUILD_CP_SOURCE=ON
run_configure
run_make
cp_log

# Add the following lines to .bashrc (or any other startup scripts)
# assuming you are use the default path and GIS_INSTALL_ROOT=~/opt
# ```
# source ~/opt/module/5.2.0/init/profile.sh
# module use ~/opt/modulefiles
#```

# run_test module list

