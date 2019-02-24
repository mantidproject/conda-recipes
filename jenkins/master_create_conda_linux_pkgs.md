## master_create_conda_linux_pkg
Run conda build by using docker. This is done only at ornl-manos. 
The packages will be uploaded to anaconda.

### Configuration

* General
  * Discard old builds
    * Startegy: Log Rotation
* Job Notification
  * Permission to Copy Artifact
    * Projects to allow: master_systemtests-conda
  * Restrict where this project can be run
    * Label Expression: conda-ubuntu-14.04-build
* Source Code Management
  * Git
    * Repositories
      * URL: git@github.com-mantid-builder:mantidproject/conda-recipes.git
* Build Environment
  * Delete workspace before build starts
  * Add timestamps to the Console Output
* Build
  * Execute Shell
    ```#!/bin/bash
    pwd
    rm -rf docker/framework/build_artefacts
    mkdir -p docker/framework/build_artefacts
    cd docker/framework && ./run_docker_build_continuumio-mc2.sh
    cd $WORKSPACE

    MF_TBS=$(ls docker/framework/build_artefacts/linux-64/mantid-framework-*.tar.bz2)
    echo $MF_TBS

    ANACONDA_ACCESS_KEY=$ANACONDA_ACCESS_KEY MC_DIR=$HOME/miniconda2 jenkins/upload.sh -l nightly --force ${MF_TBS}
    ```
* Post-build Actions
