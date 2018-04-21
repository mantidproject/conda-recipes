#!/bin/bash

# this script works for ornl manos only

# get miniconda. don't need it anymore because it is there
# wget http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh
# chmod +x miniconda.sh
# STARTING_WD=`pwd`

MC_DIR=$HOME/miniconda2  
# ./miniconda.sh -b -p $MC_DIR  # install
export PATH=$MC_DIR/bin:$PATH   # enable conda

# prepare environment
conda config --set always_yes true
conda update conda
conda create -n build python=2.7
conda install -n build anaconda-client

