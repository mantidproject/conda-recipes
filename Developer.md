# Develop mantid framework using conda

The following was tested on an Ubuntu 16.04 system. Other assumptions:

* `make` exists
* `opengl` and `glu` libs and headers are installed
* `MantidExternalData` exists in `$HOME/MantidExternalData`

Create env vars:

	$ export MANTID_SRC=/path/to/mantid/src
	$ export MANTID_BUILD=/path/to/mantid/build

Install [minconda](https://docs.conda.io/en/latest/miniconda.html) first.

Then add conda channels:

	$ conda config --add channels conda-forge
	$ conda config --add channels mantid

Create a new environment and use it:

	$ conda create -n dev-mantid
	$ source activate dev-mantid

Install dependencies (versions extracted from `framework/conda_build_config.yaml` and `framework/meta.yaml`):

	$ conda install cmake python=2.7.14 boost=1.66 eigen=3.3.3 hdf4=4.2.13 hdf5=1.8.18 \
		muparser=2.2.5=0 gsl=1.16 openblas=0.2.20 blas=1.1 numpy=1.14 poco=1.7.3 \
		nexus=4.4.3 jsoncpp=0.10.6 tbb=2018_20170919 librdkafka=0.11 readline \
		openssl python-dateutil h5py mpi4py scipy \
		scikit-image pyyaml pycifrw matplotlib six gxx_linux-64

Create a directory with opengl headers (here and in the next command the exact paths of gl headers/libs might be different than what is in your system):

	$ mkdir -p $MANTID_BUILD/GL-includes
	$ cp -a /usr/include/GL $MANTID_BUILD/GL-includes/GL

Configure build :

	$ export PREFIX=$CONDA_PREFIX
	$ export OPENGL_INCLUDES=$MANTID_BUILD/GL-includes
	$ cd $MANTID_BUILD
	$ CXXFLAGS=-I$OPENGL_INCLUDES cmake \
	  -DOPENGL_gl_LIBRARY=/usr/lib/x86_64-linux-gnu/libGL.so.1 \
	  -DOPENGL_glu_LIBRARY=/usr/lib/x86_64-linux-gnu/libGLU.so.1 \
	  -DUSE_SYSTEM_EIGEN=1 -DUSE_CXX98_ABI=TRUE  -DENABLE_MANTIDPLOT=FALSE -DENABLE_WORKBENCH=FALSE \
	  -DCMAKE_SKIP_INSTALL_RPATH=ON -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_PREFIX_PATH=$PREFIX \
	  -DENABLE_OPENCASCADE=FALSE \
	  $MANTID_SRC

Build:

	$ make -j 10

Install:

	$ make install

Post-installation fix:

	$ python_site_pkg_path=`python -c "from __future__ import print_function; import h5py, os; opd=os.path.dirname; print(opd(opd(h5py.__file__)))"`
	$ echo $python_site_pkg_path
	$ rsync -av $PREFIX/lib/mantid/ $python_site_pkg_path/mantid/

Run system tests (`-R` allows to select the tests to run):

	$ cd $MANTID_BUILD
	$ make StandardTestData
	$ make SystemTestData
	$ cd $MANTID_SRC
	$ ./Testing/SystemTests/scripts/runSystemTests.py \
		--executable=`which python` --exec-args="" -j10 \
		--output-on-failure -R SNSPowderRedux
