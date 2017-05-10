wget http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh

unset PYTHONPATH
bash miniconda.sh -b -p $HOME/opt/miniconda2
export PATH=$HOME/opt/miniconda2/bin:$PATH
conda config --add channels conda-forge
conda config --add channels mantid
## Establish mantid environment
conda create --yes --name mantid python=2
source activate mantid
conda install --yes --quiet numpy
conda install --yes --quiet mantid-framework
conda remove --yes --quiet mantid-framework
conda install --yes --quiet $1
