# conda-recipes

## Prerequisites

42. anaconda or miniconda
42. `conda-build`
42. `conda config --add channels conda-forge`
42. `conda install muparser`

## Build
First activate anaconda, then
```
$ cd framework
$ conda build .
```
and wait

In the case that `jsoncpp', poco`, and `nexus` aren't available, build
them first using the same technique.

You may need to rebuild boost ([recipe](https://github.com/conda-forge/boost-feedstock)) and muparser ([recipe](https://github.com/conda-forge/muparser-feedstock)).
## Upload to anaconda
```
$ anaconda login
$ anaconda upload /PATH/TO/CONDA/conda-bld/linux-64/mantid-framework-VERSION-py27_0.tar.bz2
```

## User installation of mantid framework conda package
```
$ conda install -c mantid mantid-framework
```

[Design document](../../../documents/blob/master/Design/Anaconda.md)
