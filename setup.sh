#!/bin/bash -e
green () {
  echo -e "\e[1m\e[32m""$1""\e[0m"
}
yellow() {
  echo -e "\e[1m\e[33m""$1""\e[0m"
}
blue () {
  echo -e "\e[1m\e[34m""$1""\e[0m"
}
fetch () {
  green "Fetching $1"
  if [ ! -e $(basename $2) ]; then
    wget "$2"
  else
    yellow "File $2 already downloaded"
  fi
}

blue "Setting up Directories"
mkdir -p os161
mkdir -p os161/toolbuild
mkdir -p os161/tools/bin
mkdir -p os161/downloads

blue "Fetching Toolchain"
fetch "binutils" http://os161.eecs.harvard.edu/download/binutils-2.24+os161-2.1.tar.gz
fetch "gcc" http://os161.eecs.harvard.edu/download/gcc-4.8.3+os161-2.1.tar.gz
fetch "gdb" http://os161.eecs.harvard.edu/download/gdb-7.8+os161-2.1.tar.gz
fetch "bmake" http://os161.eecs.harvard.edu/download/bmake-20101215.tar.gz
fetch "mk library" http://os161.eecs.harvard.edu/download/mk-20100612.tar.gz
fetch "os161 2.0.2" http://os161.eecs.harvard.edu/download/os161-base-2.0.2.tar.gz

blue  "Installing toolchain dependencies libmp libmpfr libmpc (will require root)"
sudo apt-get install libgmp-dev libmpfr-dev libmpc-dev

blue  "Building toolchain"
blue "Building Binutils"
#tar -xzvf binutils-2.24+os161-2.1.tar.gz
