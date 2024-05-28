!/bin/bash

set -eux

PY_VERSION=${PY_VERSION:-"3.8"}
CONDA_ENV_NAME=${CONDA_ENV_NAME:-"ascend"}

# create an virtual environment
conda create -n ${CONDA_ENV_NAME} python=${PY_VERSION}
conda activate ${CONDA_ENV_NAME}

# install dependencies
