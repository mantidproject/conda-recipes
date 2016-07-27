#!/usr/bin/env bash

let CORES=`grep -c ^processor /proc/cpuinfo`
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

# ----------------------------------------------------------------------
# update cmake files
git clone https://github.com/mantidproject/conda-recipes mantid-conda-recipes
rsync -av ./mantid-conda-recipes/framework/revised/ ./

# ----------------------------------------------------------------------
mkdir build; cd build
cmake -DBOOST_ROOT=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_SYSTEM_LIBRARY_PATH=$PREFIX/lib -DNEXUS_LIBRARIES=$PREFIX/lib -DNEXUS_INCLUDE_DIR=$PREFIX/include -DHDF5_DIR=$PREFIX -DMUPARSER_INCLUDE_DIR=$PREFIX/include  -DENABLE_OPENCASCADE= -DVERSION_PATCH=0  ../Framework/
make -j $CORES
make install

# move mantid
python_site_pkg_path=`python -c "import h5py, os; opd=os.path.dirname; print opd(opd(h5py.__file__))"`
mv $PREFIX/bin/mantid $python_site_pkg_path
mkdir $PREFIX/lib/mantid
ln -s $PREFIX/plugins $PREFIX/lib/mantid/plugins
