#!/usr/bin/env bash

docker run --net=host -it -v $PWD/../../..:/work -e HOST_USER_ID=lj7 condaforge/linux-anvil
