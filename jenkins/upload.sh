#!/bin/bash
set -x

# Usage: ./upload.sh  -l nightly --force /path/to/pkg.bz2

# conda
# MC_DIR=$HOME/miniconda2  
export PATH=$MC_DIR/bin:$PATH

# upload
# the tool arguments are https://docs.anaconda.com/anacondaorg/commandreference/
anaconda upload -t $ANACONDA_ACCESS_KEY $@
