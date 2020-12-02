#!/usr/bin/env bash

set -ex

mkdir build
cd build

cmake \
  -G Ninja \
  -DUSE_SYSTEM_EIGEN=ON \
  -DUSE_CCACHE=OFF \
  -DUSE_JEMALLOC=OFF \
  -DENABLE_OPENGL=OFF \
  -DENABLE_DOCS=OFF \
  -DENABLE_MANTIDPLOT=FALSE \
  -DENABLE_WORKBENCH=FALSE \
  -DENABLE_OPENCASCADE=FALSE \
  -DPython_EXECUTABLE="$CONDA_PREFIX/bin/python" \
  -DCMAKE_PREFIX_PATH=$CONDA_PREFIX \
  -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX \
  -DCMAKE_SKIP_INSTALL_RPATH=ON \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=$OSX_VERSION \
  -DHDF5_ROOT=$PREFIX \
  -DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$OSX_VERSION.sdk" \
  ..

#  -DCMAKE_FIND_DEBUG_MODE=ON \
#  -DHDF5_CXX_COMPILER_EXECUTABLE:FILEPATH=/Users/spu92482/miniconda/bin/h5c++ \
#  -DHDF5_CXX_LIBRARY_hdf5:FILEPATH=/Users/spu92482/miniconda/lib/libhdf5.dylib \
#  -DHDF5_CXX_LIBRARY_hdf5_cpp:FILEPATH=/Users/spu92482/miniconda/lib/libhdf5_cpp.dylib \
#  -DHDF5_CXX_LIBRARY_hdf5_hl:FILEPATH=/Users/spu92482/miniconda/lib/libhdf5_hl.dylib \
#  -DHDF5_CXX_LIBRARY_hdf5_hl_cpp:FILEPATH=/Users/spu92482/miniconda/lib/libhdf5_hl_cpp.dylib \
#  -DHDF5_DIFF_EXECUTABLE:FILEPATH=/Users/spu92482/miniconda/bin/h5diff \

# cmake -LA
cmake --build .
cmake --build . --target install

mv ${CONDA_PREFIX}/lib/mantid ${SP_DIR}
#mv ${CONDA_PREFIX}/lib/mantid-*-py*.egg-info ${SP_DIR}
