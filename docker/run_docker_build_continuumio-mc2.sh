#!/usr/bin/env bash

# NOTE: This script has been adapted from https://raw.githubusercontent.com/conda-forge/staged-recipes/master/scripts/run_docker_build.sh

REPO_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
ARTEFACTS_ROOT=$(pwd;)/build_artefacts2
IMAGE_NAME="continuumio/miniconda2"

rm -rf ${ARTEFACTS_ROOT}
mkdir -p ${ARTEFACTS_ROOT}
owner=$(stat -c '%u:%g' ${ARTEFACTS_ROOT})
echo "ARTEFACTS_ROOT: "${ARTEFACTS_ROOT}

config=$(cat <<CONDARC

channels:
 - conda-forge
 - mantid
 - defaults

conda-build:
 root-dir: /build_artefacts

always_yes: true
show_channel_urls: true

CONDARC
)

# In order for the conda-build process in the container to write to the mounted
# volumes, we need to run with the same id as the host machine, which is
# normally the owner of the mounted volumes, or at least has write permission
HOST_USER_ID=$(id -u)
# Check if docker-machine is being used (normally on OSX) and get the uid from
# the VM
if hash docker-machine 2> /dev/null && docker-machine active > /dev/null; then
    HOST_USER_ID=$(docker-machine ssh $(docker-machine active) id -u)
fi

cat << EOF | docker run --net=host -i \
                        -v ${REPO_ROOT}:/staged-recipes \
                        -v ${ARTEFACTS_ROOT}:/build_artefacts \
                        -a stdin -a stdout -a stderr \
                        -e HOST_USER_ID=${HOST_USER_ID} \
                        $IMAGE_NAME \
                        bash -ex || exit $?

set -e
clean_up () {
    ARG=\$?
    echo "clean_up"
    ls -l /build_artefacts
    chown -R ${owner} /build_artefacts
    exit \$ARG
}
trap clean_up EXIT
export PYTHONUNBUFFERED=1

# need opengl and glu
apt-get update
apt-get install -y freeglut3-dev make
mkdir -p ~/GL-includes
cp -a /usr/include/GL ~/GL-includes/GL
# ls /root/GL-includes
export OPENGL_gl_LIBRARY=/usr/lib/x86_64-linux-gnu/libGL.so.1
export OPENGL_glu_LIBRARY=/usr/lib/x86_64-linux-gnu/libGLU.so.1
export OPENGL_INCLUDES=/root/GL-includes

# Copy the host recipes folder so we don't ever muck with it
mkdir -p ~/conda-recipes
cp -r /staged-recipes/framework ~/conda-recipes/framework
cp -r /staged-recipes/workbench ~/conda-recipes/workbench

# condarc
echo "$config" > ~/.condarc
echo "# ~/.condarc"
cat ~/.condarc

# A lock sometimes occurs with incomplete builds. The lock file is stored in build_artefacts.
# conda clean --lock

# need conda build
conda update conda
conda install conda-build=3.17

# build
conda build ~/conda-recipes >/build_artefacts/log.build 2>&1

EOF
