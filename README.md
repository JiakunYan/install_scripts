# install_scripts

## About
This repo is used to hold installation scripts for common packages.
The idea is to make them general enough to be used on multiple platforms.

## Usage
```bash
source config/[platform].sh
./build.sh [package_name]/[version]-[release/debug]
```
By default, the script will install the specified package at 
`${GIS_INSTALL_ROOT}/[package_name]/[version]-[build_type]`.
It will also create a module file (see 
<a href=https://modules.sourceforge.net/>environment modules</a>)
at `${GIS_INSTALL_ROOT}/modulefiles/[package_name]/[version]-[build_type]`

The environmental variable `GIS_INSTALL_ROOT` is set by the platform-specific
configuration file `config/[platform].sh`.