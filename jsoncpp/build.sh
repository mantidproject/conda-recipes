#!/usr/bin/env bash

let CORES=`grep -c ^processor /proc/cpuinfo`
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_SHARED_LIBS=ON .. &&  make -j $CORES && make install
