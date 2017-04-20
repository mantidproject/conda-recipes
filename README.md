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
## Upload to anaconda
```
$ anaconda login
$ anaconda upload /PATH/TO/CONDA/conda-bld/linux-64/mantid-framework-VERSION-py27_0.tar.bz2
```

Upload with a "nightly" label:
```
$ anaconda upload /PATH/TO/CONDA/conda-bld/linux-64/mantid-framework-VERSION-py27_0.tar.bz2 -l nightly
```

## User installation of mantid framework conda package

At the moment we only have packages available for the linux64 architecture.

```
$ conda config --add channels conda-forge
$ conda install -c mantid mantid-framework
```

To install the nightly build:
```
$ conda install -c mantid/label/nightly mantid-framework
```

[Design document](../../../documents/blob/master/Design/Anaconda.md)
