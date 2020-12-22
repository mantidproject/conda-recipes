#!/usr/bin/env bash

set -ex

mkdir build
cd build

# Note that HDF5_ROOT must be specified to prevent Mantid looking in /usr/local
# Note that OSX we use system clang as at time of writing packaged clang is too old 
# Note the use of USE_PYTHON_DYNAMI_LIB=OFF conda python builds on OSX statically link to the runtime so we disable dynamic linking to avoid overwriting existing symbols
cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DUSE_JEMALLOC=OFF \
  -DUSE_CCACHE=OFF \
  -DPython_EXECUTABLE="$CONDA_PREFIX/bin/python" \
  -DCMAKE_PREFIX_PATH=$CONDA_PREFIX \
  -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=$OSX_VERSION \
  -DHDF5_ROOT=$CONDA_PREFIX \
  -DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$OSX_VERSION.sdk" \
  -DUSE_SYSTEM_EIGEN=OFF \
  -DENABLE_MANTIDPLOT=OFF \
  -DENABLE_WORKBENCH=OFF \
  -DENABLE_OPENGL=OFF \
  -DENABLE_DOCS=OFF \
  -DENABLE_OPENCASCADE=OFF \
  -DUSE_PYTHON_DYNAMIC_LIB=OFF \
  ..

cmake --build .
cmake --build . --target install

mv ${CONDA_PREFIX}/lib/mantid ${SP_DIR}
