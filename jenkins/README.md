# Jenkins configuration and scripts

There several Jenkins projects in builds.mantidproject.org to build the conda package nightly.

* [Default Redhat build -- not conda](master_clean-rhel7.md)
* [Update hash in conda recipe](master_condarecipes_update.md)
* [Linux-64 conda build](master_create_conda_linux_pkg.md)
* [Linux-64 system tests for conda build, and upload to anaconda](master_systemtests-conda.md)

## Jenkins nodes configuration

* Install docker
* Install miniconda2 at ~builder/miniconda2. Install anaconda client in the root environment

## Misc Notes
* anaconda organization: mantid
* anaconda authentication: use access key. it need to be updated once a while
