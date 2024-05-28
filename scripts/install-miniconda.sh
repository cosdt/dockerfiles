#!/bin/bash

set -eux

PLATFORM=${PLATFORM:-"linux/arm64"}
CONDA_HOME=${CONDA_HOME:-"/opt/miniconda"}

CONDA_BASE_URL="https://repo.anaconda.com/miniconda"

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

INSTALLER="Miniconda3-latest-Linux-$ARCH.sh"
CONDA_URL="$CONDA_BASE_URL/$INSTALLER"

# Download installer
echo "Downloading $INSTALLER"
wget $CONDA_URL -q -O /tmp/$INSTALLER

if [ ! $? -eq 0 ]; then
  echo "Miniconda download failed."
  exit 1
fi

# Run installation
echo "Installing $INSTALLER"
bash /tmp/$INSTALLER -b -u -p $CONDA_HOME

if [ $? -eq 0 ]; then
  echo "Miniconda installation successful."
  rm /tmp/$INSTALLER
else
  echo "Miniconda installation failed."
  rm /tmp/$INSTALLER
  exit 1
fi

# Init
$CONDA_HOME/bin/conda init
source ~/.bashrc
conda --version
