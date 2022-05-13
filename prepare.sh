#!/bin/bash

# run in an environment
# e.g.:
# python -m venv ~/v/trocr
# . ~/v/trocr/bin/activate

pip install pybind11==2.9.2

# try to add --no-cache in case of any issues
pip install -r requirements.txt
