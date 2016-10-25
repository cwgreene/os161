#!/bin/bash -e
ROOT_DIR=$(pwd)
green () {
  echo -e "\e[1m\e[32m""$1""\e[0m"
}
red() {
  echo -e "\e[1m\e[31m""$1""\e[0m"
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
checktar () {
  if [ ! -e $1 ]; then
    tar -xzvf "$1".tar.gz
  fi
}
build () {
  checktar
  cd "$1"
  shift
  "$@"
  make
  make install
  cd ..
}
check-package-dependencies (){
  for x in libgmp-dev libmpfr-dev libmpc-dev bmake; do
    if ! dpkg -s "$x" > /dev/null; then
      red "Dependencies are not installed (specifcally $x)"
      red "Run 'sudo apt-get install libgmp-dev libmpfr-dev libmpc-dev'"
      exit 1
    fi
  done
}
check-package-dependencies
mkdir -p downloads
cd downloads
blue "Setting up Directories"
mkdir -p os161
mkdir -p os161/toolbuild
mkdir -p os161/tools/bin
mkdir -p os161/downloads

blue "Fetching Toolchain"
fetch "binutils" http://os161.eecs.harvard.edu/download/binutils-2.24+os161-2.1.tar.gz
fetch "gcc" http://os161.eecs.harvard.edu/download/gcc-4.8.3+os161-2.1.tar.gz
fetch "gdb" http://os161.eecs.harvard.edu/download/gdb-7.8+os161-2.1.tar.gz
#fetch "bmake" http://os161.eecs.harvard.edu/download/bmake-20101215.tar.gz
#fetch "mk library" http://os161.eecs.harvard.edu/download/mk-20100612.tar.gz
fetch "os161 2.0.2" http://os161.eecs.harvard.edu/download/os161-base-2.0.2.tar.gz

blue  "Building toolchain"
# Binutils
blue "Building Binutils"
build binutils-2.24+os161 \
  ./configure --nfp --disable-werror --target=mips-harvard-os161 --prefix=$ROOT_DIR/os161/tools
# gcc, build directory is not in same directory. TODO: Generalize.
blue "Building gcc"
checktar gcc-4.8.3+os161-2.1
mkdir buildgcc
cd buildgcc
../gcc-4.8.3+os161-2.1/configure \
  --enable-languages=c,lto \
  --nfp --disable-shared --disable-threads \
  --disable-libmudflap --disable-libssp \
  --disable-libstdcxx --disable-nls \
  --target=mips-harvard-os161 \
  --prefix=$HOME/os161/tools
make
make install
cd ..
# gdb
blue "Building gdb"
build gdb-7.8+os161-2.1
