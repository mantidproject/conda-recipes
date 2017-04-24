#!/bin/bash
# find .

# get miniconda
# wget http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh
# chmod +x miniconda.sh
# STARTING_WD=`pwd`
MC_DIR=$HOME/miniconda2
# ./miniconda.sh -b -p $MC_DIR
export PATH=$MC_DIR/bin:$PATH
# prepare build environment
conda config --set always_yes true
conda update conda
conda config --add channels conda-forge
conda config --add channels mantid
conda install -n root conda-build
conda create -n build python=2.7
conda install -n build anaconda-client
source activate build
# anaconda settings
anaconda login --username mantid --password $ANACONDA_PASSWORD
conda config --set anaconda_upload no
# build
ls /usr/lib/x86_64-linux-gnu/libGL*
export OPENGL_gl_LIBRARY=/usr/lib/x86_64-linux-gnu/libGL.so
export OPENGL_glu_LIBRARY=/usr/lib/x86_64-linux-gnu/libGLU.so
conda build framework
# upload
# find $MC_DIR/conda-bld/linux-64
tar_ball=`ls -1 $MC_DIR/conda-bld/linux-64/mantid-framework*`
echo $tar_ball
anaconda upload $tar_ball --label nightly --force
# clean up
conda build purge
rm -f $MC_DIR/conda-bld/linux-64/mantid-framework*
