#!/bin/bash

echo ""
echo "Installing a fresh version of Miniconda."
MINICONDA_URL="https://repo.continuum.io/miniconda"
MINICONDA_FILE="Miniconda3-latest-MacOSX-x86_64.sh"
curl -L -O "${MINICONDA_URL}/${MINICONDA_FILE}"
bash $MINICONDA_FILE -b

echo ""
echo "Configuring conda."
source $HOME/miniconda3/bin/activate root
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels mantid
conda config --set show_channel_urls true
conda install conda-build
conda install anaconda-client
