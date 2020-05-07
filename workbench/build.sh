#!/usr/bin/env bash

set -ex

mkdir build
cd build

cmake \
   -G Ninja \
  -DUSE_SYSTEM_EIGEN=ON \
  -DENABLE_OPENGL=ON \
  -DENABLE_MANTIDPLOT=FALSE \
  -DENABLE_WORKBENCH=TRUE \
  -DENABLE_OPENCASCADE=FALSE \
  -DPYTHON_EXECUTABLE="$CONDA_PREFIX/bin/python" \
  -DCMAKE_PREFIX_PATH=$CONDA_PREFIX \
  -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX \
  -DCMAKE_SKIP_INSTALL_RPATH=OFF \
  -DBOOST_INCLUDEDIR="$CONDA_PREFIX/include" \
  ../

cmake --build .
cmake --build . --target install

# move mantid
python_site_pkg_path=`python -c "from __future__ import print_function; import h5py, os; opd=os.path.dirname; print(opd(opd(h5py.__file__)))"`
echo $python_site_pkg_path
mv ${CONDA_PREFIX}/lib/mantid $python_site_pkg_path/
mv ${CONDA_PREFIX}/lib/mantid-*-py*.egg-info $python_site_pkg_path/

# move other workbench related libraries
mv ${CONDA_PREFIX}/lib/mantidqt $python_site_pkg_path/
mv ${CONDA_PREFIX}/lib/workbench $python_site_pkg_path/
