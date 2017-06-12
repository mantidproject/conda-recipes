#!/bin/bash

# Usage: ./upload.sh  -l nightly --force /path/to/pkg.bz2

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/setup_mc2.sh
source activate build

# anaconda settings
anaconda login --username mantid --password $ANACONDA_PASSWORD

# upload
anaconda upload $@
