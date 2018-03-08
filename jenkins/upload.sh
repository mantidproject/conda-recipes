#!/bin/bash

# Usage: ./upload.sh  -l nightly --force /path/to/pkg.bz2

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setup_mc2.sh
source activate build

# upload
anaconda -t $ANACONDA_ACCESS_KEY upload $@
