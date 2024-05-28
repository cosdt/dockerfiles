#!/bin/bash

set -e

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

# Run installation
echo "Installing $INSTALLER"
bash /tmp/$INSTALLER -b -u -p $CONDA_HOME
rm -f /tmp/$INSTALLER
echo "Miniconda installation successful. Please restart your terminal or run 'source ${HOME}/.bashrc' to apply the changes."

# Init
$CONDA_HOME/bin/conda init bash
source /root/.bashrc
conda --version
