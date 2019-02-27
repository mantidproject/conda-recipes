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

# Move artifacts over for local install
cp -r /build_artefacts2 $CONDA_PREFIX/conda-bld

# Loop over the different packages (two python2.7.14 and one python3.6)
for package in $(echo $CONDA_PREFIX/conda-bld/mantid-framwork*)
do
  # Get python version from package name
  PYVERSION=$(echo ${package} | sed -n 's/.*-py\([0-9]\)\([0-9]\).*$/\1\.\2/p')

  # Setup the conda environment
  conda create -n mantid-local -q python=${PYVERSION}
  conda activate mantid-local
  conda install conda
  conda install conda-build

  # Install package
  conda index $CONDA_PREFIX/conda-bld
  conda install ${package}

  # Test installation
  python -c "import mantid"
  python -c "import mantid; print(mantid.__version__)"
  python -c "from mantid import simpleapi"
done

EOF
