
# Install mantid-framework using conda

At the moment we only have packages available for the linux64 architecture.

```
$ conda config --add channels conda-forge
$ conda install -c mantid mantid-framework
```

To install the nightly build:
```
$ conda install -c mantid/label/nightly mantid-framework
```

At the moment, only `linux-64` is supported.
