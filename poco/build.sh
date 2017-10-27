#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
	let CORES=`grep -c ^processor /proc/cpuinfo`
	;;
    Darwin*)
	let CORES=`sysctl -n hw.ncpu`
	export CONFIGURE_EXTRA_ARGS=--config="Darwin-clang-libc++"
	;;
    *)  echo "${unameOut} unsupported"; exit 1
esac
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

./configure ${CONFIGURE_EXTRA_ARGS} \
    --prefix=$PREFIX --include-path=$PREFIX/include --library-path=$PREFIX/lib \
    && make -j $CORES && make install 
