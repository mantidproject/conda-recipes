#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
	let CORES=`grep -c ^processor /proc/cpuinfo`
	CMAKE_EXTRA_ARGS="-DOPENGL_gl_LIBRARY=${OPENGL_gl_LIBRARY} -DOPENGL_glu_LIBRARY=${OPENGL_glu_LIBRARY}"
	if [ ! -z "$OPENGL_INCLUDES" ]; then
	   export CXXFLAGS="$CXXFLAGS -I$OPENGL_INCLUDES"
	fi
	;;
    Darwin*)
	let CORES=`sysctl -n hw.ncpu`
	export CXXFLAGS="-stdlib=libc++ -std=c++11"
	CMAKE_EXTRA_ARGS="-DHDF5_ROOT=$PREFIX"
	;;
    *)  echo "${unameOut} unsupported"; exit 1
esac
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
CXXFLAGS=${CXXFLAGS} ${CMAKE} ${CMAKE_GENERATOR} \
    ${CMAKE_EXTRA_ARGS} \
    -DUSE_SYSTEM_EIGEN=1 \
    -DUSE_CXX98_ABI=TRUE \
    -DENABLE_MANTIDPLOT=FALSE \
    -DENABLE_WORKBENCH=TRUE \
    -DCMAKE_SKIP_INSTALL_RPATH=OFF \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DENABLE_OPENCASCADE=FALSE \
    ../
${CMAKE} --build . -- -j $CORES
${CMAKE} --build . --target install

# move mantid
python_site_pkg_path=`python -c "from __future__ import print_function; import h5py, os; opd=os.path.dirname; print(opd(opd(h5py.__file__)))"`
echo $python_site_pkg_path
mv $PREFIX/bin/mantid $python_site_pkg_path/
mkdir $PREFIX/lib/mantid
ln -s $PREFIX/plugins $PREFIX/lib/mantid/plugins