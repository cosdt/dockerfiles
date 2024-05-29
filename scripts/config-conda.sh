#!/bin/bash

set -e

PY_VERSION=${PY_VERSION:-"3.8"}
CONDA_ENV_NAME=${CONDA_ENV_NAME:-"ascend"}

# create an virtual environment
conda create -n ${CONDA_ENV_NAME} python=${PY_VERSION}
conda activate ${CONDA_ENV_NAME}

# install dependencies
pip install pip --no-cache-dir --upgrade
pip install --no-cache-dir attrs cython numpy decorator sympy cffi pyyaml pathlib2 psutil protobuf scipy requests absl-py

echo "conda activate ${CONDA_ENV_NAME}" >> ~/.bashrc
source ~/.bashrc
