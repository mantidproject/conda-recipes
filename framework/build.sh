#!/usr/bin/env bash

let CORES=`grep -c ^processor /proc/cpuinfo`
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

if [ $(command -v cmake3) ]; then
    CMAKE=$(command -v cmake3)
else
    CMAKE=$(command -v cmake)
fi

if [ $(command -v ninja) ]; then
  CMAKE_GENERATOR="-G Ninja"
elif [ $(command -v ninja-build) ]; then
  CMAKE_GENERATOR="-G Ninja"
fi
if [ -e CMakeCache.txt ]; then
  CMAKE_GENERATOR=""
fi


mkdir build; cd build
${CMAKE} ${CMAKE_GENERATOR} \
    -DOPENGL_gl_LIBRARY=${OPENGL_gl_LIBRARY} \
    -DOPENGL_glu_LIBRARY=${OPENGL_glu_LIBRARY} \
    -DENABLE_MANTIDPLOT=FALSE \
    -DCMAKE_SKIP_INSTALL_RPATH=ON \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DENABLE_OPENCASCADE=FALSE \
    ../
${CMAKE} --build . -- -j $CORES
${CMAKE} --build . --target install

# move mantid
python_site_pkg_path=`python -c "from __future__ import print_function; import h5py, os; opd=os.path.dirname; print(opd(opd(h5py.__file__)))"`
mv $PREFIX/bin/mantid $python_site_pkg_path
mkdir $PREFIX/lib/mantid
ln -s $PREFIX/plugins $PREFIX/lib/mantid/plugins
