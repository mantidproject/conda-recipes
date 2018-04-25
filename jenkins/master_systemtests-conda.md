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

