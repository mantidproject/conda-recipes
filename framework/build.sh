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


# ----------------------------------------------------------------------
# update cmake files
# git clone https://github.com/mantidproject/conda-recipes mantid-conda-recipes
# rsync -av ./mantid-conda-recipes/framework/revised/ ./

# ----------------------------------------------------------------------
mkdir build; cd build
${CMAKE} ${CMAKE_GENERATOR} \
    -DENABLE_MANTIDPLOT=FALSE \
    -DCMAKE_SKIP_INSTALL_RPATH=ON \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_SYSTEM_LIBRARY_PATH=$PREFIX/lib \
    -DBOOST_ROOT=$PREFIX \
    -DNEXUS_LIBRARIES=$PREFIX/lib \
    -DNEXUS_INCLUDE_DIR=$PREFIX/include \
    -DHDF5_DIR=$PREFIX \
    -DMUPARSER_INCLUDE_DIR=$PREFIX/include \
    -DENABLE_OPENCASCADE=FALSE \
    -DOPENSSL_INCLUDE_DIR=$PREFIX/include \
    -DOPENSSL_CRYPTO_LIBRARY=$PREFIX/lib/libcrypto.so \
    -DOPENSSL_SSL_LIBRARY=$PREFIX/lib/libssl.so ../
${CMAKE} --build . -- -j $CORES
${CMAKE} --build . --target install

# move mantid
python_site_pkg_path=`python -c "import h5py, os; opd=os.path.dirname; print opd(opd(h5py.__file__))"`
mv $PREFIX/bin/mantid $python_site_pkg_path
mkdir $PREFIX/lib/mantid
ln -s $PREFIX/plugins $PREFIX/lib/mantid/plugins
