#!/usr/bin/env bash

./run_docker_build.sh && \
    anaconda upload -l candidate --force $(ls build_artefacts/linux-64/mantid-framework-*.tar.bz2) && \
    sleep 10 && \
    ./run_docker_test_centos6.sh && \
    anaconda upload -l nightly --force $(ls build_artefacts/linux-64/mantid-framework-*.tar.bz2) && \
    rm -rf build_artefacts


#   ./run_docker_test_ubuntu_latest.sh
