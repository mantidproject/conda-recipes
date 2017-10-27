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

sh autogen.sh
CFLAGS="-I $PREFIX/include" ./configure --prefix=$PREFIX --with-hdf5=$PREFIX --with-hdf4=$PREFIX; make -j $CORES; make install
