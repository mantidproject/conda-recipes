#!/usr/bin/env bash

wget --no-verbose http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh

unset PYTHONPATH
CONDA_PREFIX=$HOME/jenkins-systemtests-opt/miniconda2
bash miniconda.sh -b -p $CONDA_PREFIX
export PATH=$CONDA_PREFIX/bin:$PATH
conda config --add channels conda-forge
conda config --add channels mantid

## anaconda client
conda install -n root --yes --quiet anaconda-client

## upload conda pkg to mantid jenkins channel
anaconda -t $ANACONDA_ACCESS_KEY upload -l jenkins --force $1

## Establish mantid environment
conda create --yes --quiet --name mantid python=2
## install
source activate mantid
pwd
which conda
conda install --yes --quiet numpy

conda env list
cat ~/.condarc
conda search mantid-framework
conda install --yes -c mantid/label/jenkins mantid-framework
which python
python -c "import numpy"
python -c "import matplotlib; import mantid"
