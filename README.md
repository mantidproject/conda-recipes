# conda-recipes

## Prerequisites

* anaconda or miniconda
* `conda-build`
* `conda config --add channels conda-forge`
* `conda install muparser`

## Build
First activate anaconda, then
```
$ conda build framework
```
and wait

In the case that `jsoncpp', poco`, and `nexus` aren't available, build
them first using the same technique.

You may need to rebuild boost ([recipe](https://github.com/conda-forge/boost-feedstock)) and muparser ([recipe](https://github.com/conda-forge/muparser-feedstock)).

### Build using docker

Can be done following instructions in ./docker/framework/run_docker_build.sh

## Upload to anaconda
```
$ anaconda login
$ anaconda upload /PATH/TO/CONDA/conda-bld/linux-64/mantid-framework-VERSION-py27_0.tar.bz2
```

Upload with a "nightly" label:
```
$ anaconda upload /PATH/TO/CONDA/conda-bld/linux-64/mantid-framework-VERSION-py27_0.tar.bz2 -l nightly
```

[Design document](../../../documents/blob/master/Design/Anaconda.md)

## Using the package

To install the [conda package](https://anaconda.org/mantid/mantid-framework) without building,
see [Install.md](Install.md).
