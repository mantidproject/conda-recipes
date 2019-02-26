#!/usr/bin/env bash

ARTEFACTS_ROOT=$(pwd;)/build_artefacts_mc2
IMAGE_NAME="continuumio/miniconda2"
OS="linux-64"

cat << EOF | docker run -i \
                        -v ${ARTEFACTS_ROOT}:/build_artefacts \
                        $IMAGE_NAME 

# Install OpenGL
apt-get install -y freeglut3-dev

# Setup conda for build
echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
. ~/.bashrc
conda config --set always_yes yes
conda config --add channels conda-forge
conda config --add channels mantid

# Loop over the different packages (two python2.7.14 and one python3.6)
for package in \$(ls /build_artefacts/${OS}/mantid-workbench*); do
  # Get python version from package name
  PYTHON_VERSION=\$(echo \${package} | sed -n 's/.*-py\([0-9]\)\([0-9]\).*$/\1\.\2/p')
  VERSION=\$(echo \${package} | sed -n 's/.*mantid-workbench-\(.*\)-\(.*\)\.tar.bz2/\1/p')
  BUILD=\$(echo \${package} | sed -n 's/.*mantid-workbench-\(.*\)-\(.*\)\.tar.bz2/\2/p')

  # Setup the conda environment
  ENV="mantid-workbench-\${VERSION}-\${BUILD}"
  conda create -n \${ENV} -q python=\${PYTHON_VERSION}
  conda activate \${ENV}
  conda install conda
  conda install conda-build

  # Install package
  rsync -av /build_artefacts/ \${CONDA_PREFIX}/conda-bld/
  conda index \${CONDA_PREFIX}/conda-bld
  conda install -c \${CONDA_PREFIX}/conda-bld mantid-workbench=\${VERSION}=\${BUILD}

  # Test installation
  python -c "import mantid"
  python -c "import mantid; print(mantid.__version__)"
  python -c "from mantid import simpleapi"
  python -c "import mantidqt"
  python -c "import workbench"

  conda deactivate
done

EOF
