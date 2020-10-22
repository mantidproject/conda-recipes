#!/usr/bin/env bash

set -ex

mkdir build
cd build

cmake \
  -G Ninja \
  -DUSE_SYSTEM_EIGEN=ON \
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
  ..

cmake --build .
cmake --build . --target install

# move mantid
python_site_pkg_path=`python -c "from __future__ import print_function; import h5py, os; opd=os.path.dirname; print(opd(opd(h5py.__file__)))"`
echo $python_site_pkg_path

mv ${CONDA_PREFIX}/lib/mantid $python_site_pkg_path/
mv ${CONDA_PREFIX}/lib/mantid-*-py*.egg-info $python_site_pkg_path/
