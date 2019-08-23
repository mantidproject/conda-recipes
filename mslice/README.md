## Prerequisites

Create a conda environment:

* `conda create myenv --python=2.7`
* `conda activate myenv`
* `conda config --add channels conda-forge`

## Build

Build the `mslice` package (from the root directory of the repository) with

* `conda build -c mantid mslice`
