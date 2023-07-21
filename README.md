# install_scripts

## About
This repo is used to hold installation scripts for common packages.
The idea is to make them general enough to be used on multiple platforms.

## Setup
1. Write a platform specific configuration file `config/[platform-name].sh`. 
   We provided a template file at `config/template.sh`.
2. Modify the `get_platform_name` function in `include/common.sh` 
   to give the script a way to identify your platform.
3. Add the following line to your `~/.bashrc`.
```
module use ~/opt/modulefiles # Assume you set GIS_INSTALL_ROOT to ~/opt
```

## Usage
```bash
./run.sh build [package_name]/[version]-[release/debug]
```
By default, the script will download the source code at 
`../install_scripts_source/[package_name]-[version]` 
and install the specified package at 
`${GIS_INSTALL_ROOT}/[package_name]/[version]-[build_type]`.
It will also create a module file (see 
<a href=https://modules.sourceforge.net/>environment modules</a>)
at `${GIS_INSTALL_ROOT}/modulefiles/[package_name]/[version]-[build_type]`

The environmental variable `GIS_INSTALL_ROOT` is set by the platform-specific
configuration file `config/[platform].sh`.