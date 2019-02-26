#!/usr/bin/env bash

ARTEFACTS_ROOT=$(pwd;)/build_artefacts2
IMAGE_NAME="continuumio/miniconda2"

cat << EOF | docker run -i \
                        -v ${ARTEFACTS_ROOT}:/build_artefacts2 \
                        $IMAGE_NAME 

# Install OpenGL
apt-get install -y freeglut3-dev

# Setup conda for build
echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
. ~/.bashrc
conda config --set always_yes yes
conda config --add channels conda-forge
conda config --add channels mantid
conda create -n mantid-local -q python=2.7
conda activate mantid-local
conda install conda
conda install conda-build

# Move artifacts over for local install
mkdir -p $CONDA_PREFIX/conda-bld/linux-64
cp -r /build_artefacts2/linux-64/${MANTID_TAR_FILE} $CONDA_PREFIX/conda-bld/linux-64

# Install
conda index $CONDA_PREFIX/conda-bld
conda install -c $CONDA_PREFIX/conda-bld mantid-framework

# Test
python -c "import mantid"
python -c "import mantid; print(mantid.__version__)"

EOF
