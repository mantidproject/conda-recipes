#!/usr/bin/env bash

set -ex

mkdir build
cd build

# Using Mesa libGL paths for the Conda CDT (Core Dependency Tree) libraries
# See http://conda-forge.org/docs/maintainer/knowledge_base.html?highlight=libgl#libgl
#
# NOTE: These are variables for Legacy OpenGL (see OpenGL_GL_PREFERENCE below)
# See https://cmake.org/cmake/help/v3.15/module/FindOpenGL.html
#
export CDT_MESA_LIBGL_DIR="${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/usr"

cmake \
   -G Ninja \
  -DUSE_SYSTEM_EIGEN=ON \
  -DUSE_JEMALLOC=OFF \
  -DENABLE_OPENGL=ON \
  -DENABLE_MANTIDPLOT=FALSE \
  -DENABLE_WORKBENCH=TRUE \
  -DENABLE_OPENCASCADE=FALSE \
  -DPython_EXECUTABLE="${CONDA_PREFIX}/bin/python" \
  -DCMAKE_PREFIX_PATH=${CONDA_PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=${CONDA_PREFIX}/lib \
  -DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SKIP_INSTALL_RPATH=OFF \
  -DOpenGL_GL_PREFERENCE="LEGACY" \
  -DOPENGL_gl_LIBRARY="${CDT_MESA_LIBGL_DIR}/lib64/libGL.so.1" \
  -DOPENGL_INCLUDE_DIR="${CDT_MESA_LIBGL_DIR}/include" \
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
