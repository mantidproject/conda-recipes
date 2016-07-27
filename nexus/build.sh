#!/usr/bin/env bash

let CORES=`grep -c ^processor /proc/cpuinfo`
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

sh autogen.sh
CFLAGS="-I $PREFIX/include" ./configure --prefix=$PREFIX --with-hdf5=$PREFIX; make -j $CORES; make install
