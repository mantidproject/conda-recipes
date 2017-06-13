#!/usr/bin/env bash

# Normally the installer for systemtests run after a sucessful build of the package
# therefore the install cmd here always takes the path of the built package as the
# argument.
# Sometimes we need to test a conda package that is already in the anaconda channel.
# This scripts allows for that.

wget --no-verbose http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh

unset PYTHONPATH
CONDA_PREFIX=$HOME/jenkins-systemtests-opt/miniconda2
bash miniconda.sh -b -p $CONDA_PREFIX
export PATH=$CONDA_PREFIX/bin:$PATH
conda config --add channels conda-forge
conda config --add channels mantid

## Establish mantid environment
conda create --yes --quiet --name mantid python=2
## install
source activate mantid
conda install --yes --quiet numpy
## !!! change the following line to use different conda channel !!!
conda install --yes --quiet -c mantid/label/jenkins mantid-framework
