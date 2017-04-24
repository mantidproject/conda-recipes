#!/usr/bin/env bash

WORK=$(cd "$(dirname "$0")"; pwd;)

# In order for the conda-build process in the container to write to the mounted
# volumes, we need to run with the same id as the host machine, which is
# normally the owner of the mounted volumes, or at least has write permission
HOST_USER_ID=$(id -u)
# Check if docker-machine is being used (normally on OSX) and get the uid from
# the VM
if hash docker-machine 2> /dev/null && docker-machine active > /dev/null; then
    HOST_USER_ID=$(docker-machine ssh $(docker-machine active) id -u)
fi


cat << EOF | docker run \
		    --net=host -i\
		    -v ${WORK}:/work \
		    -a stdin -a stdout -a stderr \
		    -e HOST_USER_ID=${HOST_USER_ID} \
		    condaforge/linux-anvil \
		    bash -ex || exit $?

conda config --add channels conda-forge
conda config --add channels mantid
conda config --set always_yes true

conda create -n test-mantid python=2
source activate test-mantid

yum install -y mesa-libGLU-devel

conda install --quiet --yes -c mantid/label/candidate mantid-framework

python -c "import mantid" >/work/log.test-centos6-first-import 2>&1 || echo "first import errored"

python -c "import mantid; print(mantid.__version__)"

EOF
