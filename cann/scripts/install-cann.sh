#!/bin/bash

set -e

get_architecture() {
    # not case sensitive
    shopt -s nocasematch

    case "${PLATFORM}" in
        "linux/x86_64"|"linux/amd64")
            ARCH="x86_64"
            ;;
        "linux/aarch64"|"linux/arm64")
            ARCH="aarch64"
            ;;
        *)
            echo "Error: Unsupported architecture ${PLATFORM}."
            exit 1
            ;;
    esac

    echo "${ARCH}"
}

PLATFORM=${PLATFORM:=$(uname -s)/$(uname -m)}
ARCH=$(get_architecture)
CANN_HOME=${CANN_HOME:="/usr/local/Ascend"}
CANN_CHIP=${CANN_CHIP:="all"}
CANN_VERSION=${CANN_VERSION:="8.0.RC1"}

# install dependencies
HW_MIRROR=https://repo.huaweicloud.com/repository/pypi/simple
pip install --no-cache-dir --upgrade pip -i ${HW_MIRROR}
pip config set global.index-url ${HW_MIRROR}
pip install --no-cache-dir attrs cython numpy decorator sympy cffi pyyaml pathlib2 psutil protobuf scipy requests absl-py

CANN_URL_PREFIX="https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%20${CANN_VERSION}"
CANN_TOOLKIT_FILE=Ascend-cann-toolkit_${CANN_VERSION}_linux-${ARCH}.run
CANN_KERNELS_FILE=Ascend-cann-kernels-${CANN_CHIP}_${CANN_VERSION}_linux.run
CANN_TOOLKIT_URL="${CANN_URL_PREFIX}/${CANN_TOOLKIT_FILE}?response-content-type=application/octet-stream"
CANN_KERNELS_URL="${CANN_URL_PREFIX}/${CANN_KERNELS_FILE}?response-content-type=application/octet-stream"

# Download CANN Toolkit
echo "Downloading $CANN_TOOLKIT_FILE"
wget ${CANN_TOOLKIT_URL} -q -O /tmp/${CANN_TOOLKIT_FILE}

# Install CANN Toolkit
echo "Installing $CANN_TOOLKIT_FILE"
chmod +x /tmp/${CANN_TOOLKIT_FILE}
bash /tmp/${CANN_TOOLKIT_FILE} --quiet --install --install-for-all --install-path=${CANN_HOME}
rm -f /tmp/${CANN_TOOLKIT_FILE}

# Init
CANN_TOOLKIT_ENV_FILE="${CANN_HOME}/ascend-toolkit/set_env.sh"
if [ ! -e ${CANN_TOOLKIT_ENV_FILE} ]; then
  echo "CANN Toolkit ${CANN_VERSION} installation failed."
  exit 1
fi

echo "source ${CANN_TOOLKIT_ENV_FILE} " >> ~/.bashrc
source ~/.bashrc

# Download CANN Kernels
echo "Downloading $CANN_KERNELS_FILE"
wget ${CANN_KERNELS_URL} -q -O /tmp/${CANN_KERNELS_FILE}

# Install CANN Kernels
echo "Installing $CANN_KERNELS_FILE"
chmod +x /tmp/${CANN_KERNELS_FILE}
bash /tmp/${CANN_KERNELS_FILE} --quiet --install --install-for-all --install-path=${CANN_HOME}
rm -f /tmp/${CANN_KERNELS_FILE}

echo "CANN ${CANN_VERSION} installation successful."
