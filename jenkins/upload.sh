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

# upload
anaconda -v upload -t $ANACONDA_ACCESS_KEY $@ 2>&1
echo "anaconda returned $?"

# cleanup
conda deactivate
