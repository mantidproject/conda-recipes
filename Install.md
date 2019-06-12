
# Install mantid-framework using conda

At this moment we only have packages available for the linux-64 architecture.


First install miniconda from https://docs.conda.io/en/latest/miniconda.html and add it to `PATH`, and add the `conda-forge` channel

```
$ conda config --add channels conda-forge
$ conda config --add channels mantid
```

Then create a new conda environment and activate it:

```
$ conda create -n mantid
$ source activate mantid
```

Now install the mantid package
```
$ conda install -c mantid mantid-framework python={VERSION}
```

Here `{VERSION}` is the version of python you want to install mantid for. For example to install mantid with python version 3, do

```
$ conda install -c mantid mantid-framework python=3
```


To install the nightly build:
```
$ conda install -c mantid/label/nightly mantid-framework python={VERSION}
```
