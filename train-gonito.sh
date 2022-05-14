#!/bin/bash -e

cd code/trocr-runner
./train.sh

cd ../..

for t in dev-0 test-A
do
    ./predict.sh < $t/in.tsv > $t/out.tsv
done
