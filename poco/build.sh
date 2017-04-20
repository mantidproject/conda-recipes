#!/usr/bin/env bash

let CORES=`grep -c ^processor /proc/cpuinfo`
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

./configure --prefix=$PREFIX --include-path=$PREFIX/include --library-path=$PREFIX/lib \
	&& make -j $CORES && make install 
