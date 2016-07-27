#!/usr/bin/env bash

let CORES=`grep -c ^processor /proc/cpuinfo`
let CORES-=1
if ((CORES < 1)); then
    CORES = 1;
fi

# ----------------------------------------------------------------------
# deps
mkdir -p deps
cd deps

# poco 1.7.3
wget http://pocoproject.org/releases/poco-1.7.3/poco-1.7.3-all.tar.gz
tar xvfz poco-1.7.3-all.tar.gz
cd poco-1.7.3-all
./configure --prefix=$PREFIX && make -j $CORES && make install 
cd ..

# neuxs 4.3.1
wget https://github.com/nexusformat/code/releases/download/4.3.1/nexus-4.3.1.tar.gz
tar xvfz nexus-4.3.1.tar.gz
cd nexus-4.3.1
CFLAGS="-I $PREFIX/include" ./configure --prefix=$PREFIX --with-hdf5=$PREFIX; make -j $CORES; make install
cd ..

# jsoncpp 0.10.6
wget https://github.com/open-source-parsers/jsoncpp/archive/0.10.6.tar.gz -O jsoncpp-0.10.6.tar.gz
tar xvfz jsoncpp-0.10.6.tar.gz
cd jsoncpp-0.10.6
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_SHARED_LIBS=ON .. &&  make -j $CORES && make install
cd .. # back out from build
cd .. # back to deps
cd .. # back

# ----------------------------------------------------------------------
mkdir build; cd build
cmake -DBOOST_ROOT=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_SYSTEM_LIBRARY_PATH=$PREFIX/lib -DNEXUS_LIBRARIES=$PREFIX/lib -DNEXUS_INCLUDE_DIR=$PREFIX/include -DHDF5_DIR=$PREFIX -DMUPARSER_INCLUDE_DIR=$PREFIX/include  -DENABLE_OPENCASCADE= -DVERSION_PATCH=100  ../Framework/
make -j $CORES
make install

# move mantid
python_site_pkg_path=`python -c "import h5py, os; opd=os.path.dirname; print opd(opd(h5py.__file__))"`
mv $PREFIX/bin/mantid $python_site_pkg_path
mkdir $PREFIX/lib/mantid
ln -s $PREFIX/plugins $PREFIX/lib/mantid/plugins
