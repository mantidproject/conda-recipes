#!/bin/bash
set -x  # turn on debug printing

# Usage: ./upload.sh  -l nightly --force /path/to/pkg.bz2
# anaconda arguments are https://docs.anaconda.com/anacondaorg/commandreference/

# verify that the upload token is supplied
if [ -z "$ANACONDA_ACCESS_KEY" ]; then
  echo "ANACONDA_ACCESS_KEY is not set"
  exit 255
fi

# activate anaconda
if [ -f "$MC_DIR/bin/activate" ]; then
  echo "Activate anacconda"
  source "$MC_DIR/bin/activate"
else
  echo "Failed to find anaconda install"
  exit 255
fi

# add location of anaconda to the path
#echo "Adding $MC_DIR/bin to the PATH"  
#export PATH=$MC_DIR/bin:$PATH

if [ ! $(command -v anaconda) ]; then
  echo "Failed to find anaconda command"
  exit 255
fi

# tool was last updated using "conda install python=2.7.16 anaconda-client" in the "base" environment
# show tool version
anaconda --version

# HACK: Patch anaconda-client to show an error message.
# taken from https://github.com/Anaconda-Platform/anaconda-client/pull/564
# the following was run on the build server directly
# conda install wget git
# cd "$(conda info|grep 'active env location'|awk '{print $5}')/lib/python"*"/site-packages/"
# wget https://github.com/Anaconda-Platform/anaconda-client/commit/bb74857cbc0b59e9c328fbf7e31caaedbc1bb9f9.diff
# git apply bb74857cbc0b59e9c328fbf7e31caaedbc1bb9f9.diff
# rm bb74857cbc0b59e9c328fbf7e31caaedbc1bb9f9.diff
# cd -

# upload
anaconda -v -t $ANACONDA_ACCESS_KEY upload -u mantid $@ 2>&1
