# To build

Run the `run_docker_build_continuumio-mc2.sh` script to make the build artifacts for the Linux Python 2.7 and 3.6 packages.
These will be the `*.tar.bz2` files in the `build-artefacts_mc2/linux-64/` directory.

# To test locally
Run the `run_docker_test_continuumio-mc2_for_local_build_artifacts.sh` script to test the locally built package artifacts (these `*.tar.bz2` files)
This will just check that the framework is installed correctly.

To do a "launch workbench" test in a new conda environment (say `mantid-workbench-test`), use the following steps:
1) `conda create -n mantid-workbench-test -q python=$PYTHON_VERSION` where `PYTHON_VERSION` is equal to either `2.7` or `3.6`.
2) `conda activate mantid-workbench-test`
3) `conda install conda conda-build`
4) `rsync -av ./build_artefacts_mc2 ${CONDA_PREFIX}/conda-bld/` where `build_artefacts_mc2` is the directory create from the build step
5) `conda index ${CONDA_PREFIX}/conda-bld`
6) `conda install -c ${CONDA_PREFIX}/conda-bld mantid-workbench=${VERSION}=${BUILD}` where VERSION and BUILD are the package version and build labels, respectively.
   Example: for the package file `mantid-workbench-3.13.20190225.1515-py27h34a23fa_0.tar.bz2`, then `VERSION=3.13.20190225.1515` and `BUILD=py27h34a23fa_0`
7) launch `mantidworkbench` and wait for workbench to open (if all goes well)

# To change / reconfigure
The two main files to change are the `../../workbench/meta.yaml` and `../../workbench/conda_build_config.yaml` files for dependency packages and the pinned version numbers.
Adjust these if needed and rerun the `run_docker_build_continuumio-mc2.sh` script to re-make the build artifacts. 

NOTE: You may have to `sudo` remove the old build artifacts due to how the docker container is setup. Thus, you can run the following if iteratively re-creating the package:
`sudo rm -rf build_artefacts_mc2 && ./run_docker_build_continuumio-mc2.sh`


# To upload manually
Via the command line, first make sure you have anaconda-client installed:
0) `conda install anaconda-client` for base environment or `conda install -n <environment> anaconda-client` for a specific environment
Then,
1) `conda activate` or `conda activate -n environment`
2) `anaconda upload -u mantid <package *.tar.bz2 file>`
Example: `anaconda upload -u mantid ./build_artefacts_mc2/linux-64/mantid-workbench-3.13.20190225.1515-py36hd0829d1_0.tar.bz2`
