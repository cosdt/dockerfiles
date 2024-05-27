#!/bin/bash

ARCH=${ARCH:-"aarch64"}
CANN_TOOLKIT_VERSION=${CANN_TOOLKIT_VERSION:-"8.0.RC1"}

CANN_TOOLKIT_FILE=Ascend-cann-toolkit_${CANN_TOOLKIT_VERSION}_linux-${ARCH}.run
CANN_TOOLKIT_URL="https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%20${CANN_TOOLKIT_VERSION}/${CANN_TOOLKIT_FILE}"

# Download CANN Toolkit
wget -q -O /tmp/${CANN_TOOLKIT_FILE} ${CANN_TOOLKIT_URL}
if [ ! $? -eq 0 ]; then
  echo "CANN download failed."
  exit 1
fi

# Install CANN Toolkit
chmod +x /tmp/${CANN_TOOLKIT_FILE}
/tmp/${CANN_TOOLKIT_FILE} --check --quiet --install --install-for-all

if [ $? -eq 0 ]; then
  echo "CANN installation successful."
  rm -f /tmp/${CANN_TOOLKIT_FILE}
else
  echo "CANN installation failed."
  rm -f /tmp/${CANN_TOOLKIT_FILE}
  exit 1
fi

# Init
echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh " >> /etc/profile
source /etc/profile
