# Wrapper for running TrOCR for Gonito challenges

## Instructions

In general, we're going to follow GEval/Gonito [reproducibility
standards](https://gitlab.com/filipg/geval#reproducibility-guidelines).

Clone a Gonito "bare" OCR/HWR challenge ("Bare" — just recognition,
no detection of text lines), e.g.:

    git://gonito.net/fiszki-bare-hwr

You'll likely need to get annexed files:

    cd fiszki-bare-hwr
    ./get-annexed-files.sh

Hook up this repo as a subrepo:

    mkdir -p code
    cd code
    git submodule add https://github.com/filipggg/trocr-runner.git

Install all requirements (preferably in an virtual env):

    python -m env ~/v/trocr
    . ~/v/trocr/bin/activate
    (cd trocr-runner && ./prepare.sh)

Run helper script:

    cd trocr-runner
    ./install.sh
    cd ../..

Now you edit `gonito.yaml` file to change default parameters.

Run training:

    CUDA_VISIBLE_DEVICES=0 ./train.sh
