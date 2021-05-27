#!/bin/bash
set -x  # turn on debug printing

# Usage: ./upload.sh  -l nightly --force /path/to/pkg.bz2
# anaconda arguments are https://docs.anaconda.com/anacondaorg/commandreference/

# verify that the upload token is supplied
if [ -z "$ANACONDA_ACCESS_KEY" ]; then
  echo "ANACONDA_ACCESS_KEY is not set"
  exit 255
fi

# add location of anaconda to the path
echo "Adding $MC_DIR/bin to the PATH"  
export PATH=$MC_DIR/bin:$PATH

if [ ! $(command -v anaconda) ]; then
  echo "Failed to find anaconda command"
  exit 255
fi

# show tool version
anaconda --version

# upload
anaconda -v upload -t $ANACONDA_ACCESS_KEY $@
echo "anaconda returned $?"
