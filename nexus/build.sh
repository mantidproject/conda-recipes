#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
	let CORES=`grep -c ^processor /proc/cpuinfo`
	;;
    Darwin*)
	let CORES=`sysctl -n hw.ncpu`
	export CXXFLAGS="-stdlib=libc++ -std=c++11 -Wno-narrowing"
	;;
    *)  echo "${unameOut} unsupported"; exit 1
esac
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DENABLE_HDF4=ON -DHDF4_ROOT=$PREFIX -DENABLE_HDF5=ON -DHDF5_ROOT=$PREFIX -DENABLE_CXX=ON ..
make -j $CORES
make install
