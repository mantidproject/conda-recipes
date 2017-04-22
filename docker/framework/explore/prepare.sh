#!/usr/bin/env bash

config=$(cat <<CONDARC

channels:
 - conda-forge
 - mantid
 - defaults

conda-build:
 root-dir: /work/docker/framework/interactive/build_artefacts

always_yes: true
show_channel_urls: true

CONDARC
)

yum install -y mesa-libGLU-devel
export OPENGL_gl_LIBRARY=/usr/lib64/libGL.so
export OPENGL_glu_LIBRARY=/usr/lib64/libGLU.so

export CONDA_NPY='111'
echo "$config" > ~/.condarc

# A lock sometimes occurs with incomplete builds. The lock file is stored in build_artefacts.
conda clean --lock
conda update conda conda-build
conda install conda-build-all

# conda build-all ~/conda-recipes --matrix-conditions "numpy ==1.11" "python ==2.7" "r-base >=3.3.2"
