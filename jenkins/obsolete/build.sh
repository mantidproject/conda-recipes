#!/bin/bash

# this script works for ornl manos only

# find .

# get miniconda. don't need it anymore because it is there
# wget http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh
# chmod +x miniconda.sh
# STARTING_WD=`pwd`

# we still need anaconda for upload
MC_DIR=$HOME/miniconda2
# ./miniconda.sh -b -p $MC_DIR
export PATH=$MC_DIR/bin:$PATH

# prepare build environment
conda config --set always_yes true
conda update conda
conda create -n build python=2.7
conda install -n build anaconda-client
source activate build
# anaconda settings
# anaconda login --username mantid --password $ANACONDA_PASSWORD
conda config --set anaconda_upload no
# build
cd ../docker/framework && ./all.sh
