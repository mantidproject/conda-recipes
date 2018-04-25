# Jenkins configuration and scripts

There several Jenkins projects in builds.mantidproject.org to build the conda package nightly.

## master_clean-rhel7
Among other things, it generates an artifact called "conda_update_recipe.py" with the right version number of mantid.

## master_condarecipes_update
* Update mantid-framework conda recipe by running "conda_update_recipe.py".
* git push to mantidproject/conda-recipes

### Configuration
* General
  * Discard old builds
    * Startegy: Log Rotation
      * Days to keep builds: 14
* Job Notification
  * Restrict where this project can be run
    * Label Expression: master
* Source Code Management
  * Git
    * Repositories
      * URL: git@github.com-mantid-builder:mantidproject/conda-recipes.git
* Build Environment
  * Delete workspace before build starts
  * Add timestamps to the Console Output
* Build
  * Copy artifacts from another project
    * name: master_clean-rhel7
    * Artifacts to copy: */*/*.py
    * Target directory: build
    * Flatten directories
    * Fingerprint Artifacts
  * Execute Python script
    ```
    import sys, os, subprocess as sp, shlex
    sys.path.insert(0, os.path.abspath("build"))
    import conda_update_recipe as cur
    repo = os.path.abspath(".")
    if cur.update_meta_yaml(repo, "framework"):
       cmd = 'git -c user.name="jenkins" -c user.email="mantid-buildserver@mantidproject.org" commit -m "update version and git_rev" framework/meta.yaml'
       sp.check_call(shlex.split(cmd), cwd=repo)
    ```
* Post-build Actions
  * Git Publisher
    * Push Only If Build Succeeds
    * Branches: branch:master; target remote: origin
  * Build other projects
    * master_create_conda_linux_pkg

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


## master_systemtests-conda
* upload the artifact to anaconda with label "jenkins"
* Run system tests by using the conda package built in the last step
* If all tests pass, upload conda package to anaconda with new label "nightly"

### Configuration

* General
  * Discard old builds
    * Startegy: Log Rotation
    * Days to keep: 30
* Job Notification
  * Restrict where this project can be run
    * Label Expression: conda-ubuntu-14.04-build
* Source Code Management
  * Git
    * Repositories
      * URL: git://github.com/mantidproject/mantid
* Build Environment
  * Delete workspace before build starts
  * Add timestamps to the Console Output
  * ￼Inject passwords to the build as environment variables
    * Job passwords
      * Name: ANACONDA_ACCESS_KEY
* Build
  * Copy artifacts from another project
    * name: master_create_conda_linux_pkg
    * which build: Latest successful
    * Stable build only
    * Artifacts to copy: docker/framework/build_artefacts/linux-64/*.tar.bz2
    * Target directory: build
    * Flatten directories
    * Fingerprint artifacts
  * Execute Shell
    ```
    rm -rf conda-recipes
    git clone https://github.com/mantidproject/conda-recipes
    rsync -av conda-recipes/jenkins/Testing/ Testing/ # update Testing to run tests using conda package
    ./buildconfig/Jenkins/systemtests && \
    ANACONDA_ACCESS_KEY=$ANACONDA_ACCESS_KEY MC_DIR=$HOME/miniconda2 conda-recipes/jenkins/upload.sh -l nightly --force $(ls build/mantid-framework-*.tar.bz2)
    ```
* Post-build Actions
  * Archive the artifacts
    * files to archive:
  * Publish JUnit test result report
    * Test report XMLs: build/Testing/SystemTests/scripts/TEST-*.xml




## Misc Notes
* anaconda organization: mantid
* anaconda authentication: use access key. it need to be updated once a while
