#!/usr/bin/env bash

# NOTE: This script has been adapted from https://raw.githubusercontent.com/conda-forge/staged-recipes/master/scripts/run_docker_build.sh

REPO_ROOT=$(cd "$(dirname "$0")/../.."; pwd;)
ARTEFACTS_ROOT=$(pwd;)/build_artefacts
IMAGE_NAME="condaforge/linux-anvil"

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

# Copy the host recipes folder so we don't ever muck with it
# Only copy the framework
mkdir -p ~/conda-recipes
cp -r /staged-recipes/framework ~/conda-recipes/framework
# cp -r /staged-recipes/poco ~/conda-recipes/poco
# cp -r /staged-recipes ~/conda-recipes

echo "$config" > ~/.condarc

# A lock sometimes occurs with incomplete builds. The lock file is stored in build_artefacts.
conda clean --lock

conda update conda conda-build

# need opengl and glu
export OPENGL_gl_LIBRARY=/usr/lib64/libGL.so
export OPENGL_glu_LIBRARY=/usr/lib64/libGLU.so
yum install -y mesa-libGLU-devel

# build
conda build --python 2.7 --numpy 1.11 ~/conda-recipes/framework

EOF
