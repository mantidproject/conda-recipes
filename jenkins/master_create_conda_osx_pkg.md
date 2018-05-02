## master_create_conda_osx_pkg
Run conda build. Currently only handled by snowleopard-builder.sns.gov.


### Configuration

* General
  * Discard old builds
    * Startegy: Log Rotation
  * GitHub project
    * Proj url: http://github.com/mantidproject/conda-recipes/
* Job Notification
  * Restrict where this project can be run
    * Label Expression: osx-conda
* Source Code Management
  * Git
    * Repositories
      * URL: git@github.com-mantid-builder:mantidproject/conda-recipes.git
* Build Triggers
  * Poll SCM. Schedule: @midnight.
* Build Environment
  * Add timestamps to the Console Output
  * Inject passwords to the build as environment variables
    * Job passwords
      * Mask password parameters
  * Run Xvnc during build
    * Create a dedicated Xauthority file per build
* Build
  * Execute Shell
    ```#!/bin/bash
    export MC_DIR=$HOME/miniconda3
    export PATH=$MC_DIR/bin:$PATH
    bash $WORKSPACE/jenkins/osx-build.sh
    TARBALLS=`ls $MC_DIR/conda-bld/osx-64/mantid-framework-*.tar.bz2`
    ANACONDA_ACCESS_KEY=$ANACONDA_ACCESS_KEY \
         $WORKSPACE/jenkins/upload.sh \
	 -l nightly \
	 --force $TARBALLS &&\
	 rm -f $TARBALLS
    ```
