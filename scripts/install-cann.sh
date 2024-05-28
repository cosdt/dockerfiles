#!/bin/bash

set -eux

PLATFORM=${PLATFORM:-"linux/arm64"}
CANN_HOME=${CANN_HOME:-"/usr/local/Ascend"}
CANN_CHIP=${CANN_CHIP:-"all"}
CANN_VERSION=${CANN_VERSION:-"8.0.RC1"}

case "$PLATFORM" in
    "linux/x86_64"|"linux/amd64")
        ARCH="x86_64"
        ;;
    "linux/aarch64"|"linux/arm64")
        ARCH="aarch64"
        ;;
    *)
        echo "Error: Unsupported architecture $PLATFORM."
        exit 1
        ;;
esac

CANN_URL_PREFIX="https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%20${CANN_VERSION}"
CANN_TOOLKIT_FILE=Ascend-cann-toolkit_${CANN_VERSION}_linux-${ARCH}.run
CANN_KERNELS_FILE=Ascend-cann-kernels-${CANN_CHIP}_${CANN_VERSION}_linux.run
CANN_TOOLKIT_URL="${CANN_URL_PREFIX}/${CANN_TOOLKIT_FILE}?response-content-type=application/octet-stream"
CANN_KERNELS_URL="${CANN_URL_PREFIX}/${CANN_KERNELS_FILE}?response-content-type=application/octet-stream"

# Install CANN Toolkit
wget ${CANN_TOOLKIT_URL} -q -O /tmp/${CANN_TOOLKIT_FILE}
bash +x /tmp/${CANN_TOOLKIT_FILE} --check --quiet --install --install-for-all --install-path=${CANN_HOME}
rm -f /tmp/${CANN_TOOLKIT_FILE}

# Init
# echo "source $CANN_HOME/set_env.sh " >> /etc/profile
# source /etc/profile

# Install CANN Kernels
wget ${CANN_KERNELS_URL} -q -O /tmp/${CANN_KERNELS_FILE}
bash +x /tmp/${CANN_KERNELS_FILE} --check --quiet --install --install-for-all --install-path=${CANN_HOME}
rm -f /tmp/${CANN_KERNELS_FILE}
