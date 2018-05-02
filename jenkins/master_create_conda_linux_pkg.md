## master_create_conda_linux_pkg
Run conda build by using docker. This is done only at ornl-manos. 
The conda package will be built as an artifact.

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
    cd docker/framework && ./run_docker_build.sh
    ```
* Post-build Actions
  * Archive the artifacts
    * files to archive: docker/framework/build_artefacts/linux-64/*.bz2
  * Build other projects
    * master_systemtests-conda
