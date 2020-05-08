#!/usr/bin/env bash

set -ex

mkdir build
cd build

# Mesa libGL paths for the Conda CDT (Core Dependency Tree) libraries
# See http://conda-forge.org/docs/maintainer/knowledge_base.html?highlight=libgl#libgl
#
# NOTE: These are variables for Legacy OpenGL (see OpenGL_GL_PREFERENCE below)
# See https://cmake.org/cmake/help/v3.15/module/FindOpenGL.html
#
export CDT_MESA_LIBGL_DIR="${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/usr"
export OPENGL_gl_LIBRARY="${CDT_MESA_LIBGL_DIR}/libGL.so.1"
export OPENGL_INCLUDE_DIR="${CDT_MESA_LIBGL_DIR}/include/GL"
export OPENGL_glu_LIBRARY="${CONDA_PREFIX}/lib/libGLU.so.1"

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
  -DOpenGL_GL_PREFERENCE="LEGACY" \
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
