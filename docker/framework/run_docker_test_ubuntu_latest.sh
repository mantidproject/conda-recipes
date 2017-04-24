#!/usr/bin/env bash

cat << EOF | docker run \
  --net=host -i\
  -a stdin -a stdout -a stderr \
  -e HOST_USER_ID=lj7 \
  ubuntu \
  bash || exit $?

apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.1.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh    

apt-get install -y curl grep sed dpkg

source /etc/profile.d/conda.sh
conda config --add channels conda-forge
conda config --add channels mantid
conda config --set always_yes true

conda install --quiet --yes -c mantid/label/candidate mantid-framework

apt-get install -y freeglut3-dev

python -c "import mantid; print(mantid.__version__)"

EOF
