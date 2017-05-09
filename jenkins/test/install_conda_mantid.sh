wget http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh

unset PYTHONPATH
bash miniconda.sh -b -p /opt/miniconda2
export PATH=/opt/miniconda2/bin:$PATH
conda config --add channels conda-forge
conda config --add channels mantid
## Establish mantid environment
conda create --yes --name mantid python=2
source activate mantid
conda install --yes numpy
conda install --yes mantid-framework
conda remove --yes mantid-framework
conda install --yes $1
