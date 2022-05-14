#!/bin/bash -x

git submodule init
git submodule update --recursive

cp gonito.yaml ../../
cp train-gonito.sh ../../train.sh
cp predict-gonito.sh ../../predict.sh
