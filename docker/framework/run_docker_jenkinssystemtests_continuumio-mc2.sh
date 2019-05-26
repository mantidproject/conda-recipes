#!/usr/bin/env bash
# Script to run jenkins systemtests for mantid-framework conda package using a docker container
# assume
# 1) mantid src tree exists
# 2) mantidexternaldata directory exists
# 3) a mantid-framework conda package
#
# Example command line
#
#   $ BUILD_THREADS=20 ./run_docker_jenkinssystemtests_continuumio-mc2.sh build_artefacts2/linux-64/mantid-framework-3.13.20190225.1515-py27h5d0adaf_0.tar.bz2  /home/lj7/dv/mantid/mantid ~/MantidExternalData &>log.test &
# 
# see results in $MANTID_SRCROOT/build/Testing/SystemTests/scripts/TEST-*.xml

MANTID_CONDA_TARBALL=$1
MANTID_SRCROOT=$2
MANTID_EXTDATADIR=$3

# put tarball in the right place
mkdir -p $MANTID_SRCROOT/build/
cp $MANTID_CONDA_TARBALL $MANTID_SRCROOT/build/

# starting docker
IMAGE_NAME="continuumio/miniconda2"
owner=$(stat -c '%u:%g' ${MANTID_SRCROOT})

cat << EOF | docker run --net=host -i \
		    -v ${MANTID_SRCROOT}:/mantidsrc \
		    -v ${MANTID_EXTDATADIR}:/mantidextdata \
                    -a stdin -a stdout -a stderr \
                    $IMAGE_NAME \
                    bash -ex || exit $?

# the following runs in the docker
set -e

# clean up code after everything is done
clean_up () {
    ARG=\$?
    echo "clean_up"
    chown -R ${owner} /mantidsrc  # chown of build results. otherwise will be owned by root
    exit \$ARG
}
trap clean_up EXIT

# Install OpenGL
apt-get install -y freeglut3-dev make

# Setup conda for build
echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
. ~/.bashrc
conda config --set always_yes yes
conda config --add channels conda-forge
conda config --add channels mantid

# Setup the conda environment
ENV="mantid-systemtests"
conda create -n \${ENV} -q python=2
conda activate \${ENV}
conda install cmake gxx_linux-64

# external data
ln -s /mantidextdata ~/MantidExternalData

# copy source tree
rsync -a /mantidsrc/ ~/mantidsrc/

# env vars needed for conda system tests
export MANTID_FRAMEWORK_CONDA_SYSTEMTEST=1
export WORKSPACE=~/mantidsrc
export BUILD_THREADS=${BUILD_THREADS}

# build
ls /mantidsrc
cd ~/mantidsrc
EXTRA_ARGS="-E ILLDirectGeometryReductionTest.IN4" timeout 10000 ./buildconfig/Jenkins/systemtests

# clean up
conda deactivate

# copy output
mkdir -p /mantidsrc/build/Testing/SystemTest/
rsync -av ~/mantidsrc/build/Testing/SystemTests/ /mantidsrc/build/Testing/SystemTest/

EOF
