#!/usr/bin/env bash
set -ex

mkdir build
cd build

cmake \
  ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_FIND_FRAMEWORK=LAST \
  -DENABLE_DOCS=OFF \
  -DWORKBENCH_SITE_PACKAGES=$SP_DIR \
  -DWORKBENCH_BIN_DIR=$PREFIX/bin \
  -DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$OSX_VERSION.sdk" \
  -DENABLE_PRECOMMIT=OFF \
  -DCONDA_BUILD=True \
  -DCONDA_ENV=True \
  -DUSE_PYTHON_DYNAMIC_LIB=OFF \
  -DMANTID_FRAMEWORK_LIB=SYSTEM \
  -DMANTID_QT_LIB=SYSTEM \
  -DENABLE_WORKBENCH=ON \
  -DQt5_DIR=$PREFIX/lib/cmake/qt5 \
  -GNinja \
  ../

ninja
ninja install
