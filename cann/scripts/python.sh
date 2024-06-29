#!/bin/bash

set -e

PY_VERSION=${PY_VERSION:-"3.8"}
PY_MAJOR_VERSION=$(echo $PY_VERSION | cut -d'.' -f1)

# Find the latest version
PY_LATEST_VERSION=$(curl -s https://www.python.org/ftp/python/ | grep -oE "${PY_VERSION}\.[0-9]+" | sort -V | tail -n 1)
if [ -z "${PY_LATEST_VERSION}" ]; then
    echo "Could not find the latest version for Python ${PY_VERSION}"
    exit 1
else
    echo "Latest Python version found: ${PY_LATEST_VERSION}"
fi

PY_HOME="/usr/local/python${PY_VERSION}"
PY_INSTALLER_TGZ="Python-${PY_LATEST_VERSION}.tgz"
PY_INSTALLER_DIR="Python-${PY_LATEST_VERSION}"
PY_INSTALLER_URL="https://repo.huaweicloud.com/python/${PY_LATEST_VERSION}/${PY_INSTALLER_TGZ}"

download_python() {
    # download python
    echo "Downloading ${PY_INSTALLER_TGZ} from ${PY_INSTALLER_URL}"
    curl -fsSL -o "/tmp/${PY_INSTALLER_TGZ}" "${PY_INSTALLER_URL}"
    if [ $? -ne 0 ]; then
        echo "Python ${PY_LATEST_VERSION} download failed."
        exit 1
    fi
}

install_python() {
    # Download installer
    if [ ! -f "/tmp/${PY_INSTALLER_TGZ}" ]; then
        echo "[WARNING] Installer do not exist, re-download it."
        download_python
    fi

    # install python
    echo "Installing ${PY_INSTALLER_DIR}"
    tar -xf /tmp/${PY_INSTALLER_TGZ} -C /tmp
    cd /tmp/${PY_INSTALLER_DIR}
    mkdir -p /${PY_HOME}/lib
    ./configure --prefix=${PY_HOME} --enable-shared LDFLAGS="-Wl,-rpath ${PY_HOME}/lib"
    make -j$($(nproc) + 1)
    make altinstall

    # create symbolic links
    create_links

    # clean up
    rm -rf /tmp/${PY_INSTALLER_TGZ} /tmp/${PY_INSTALLER_DIR}
    echo "Python ${PY_LATEST_VERSION} installation successful."
    python -c "import sys; print(sys.version)"
}

# create links
create_links() {
    ln -sf ${PY_HOME}/bin/python${PY_VERSION} /usr/bin/python${PY_VERSION}
    ln -sf ${PY_HOME}/bin/pip${PY_VERSION} /usr/bin/pip${PY_VERSION}
    ln -sf /usr/bin/python${PY_VERSION} /usr/bin/python${PY_MAJOR_VERSION}
    ln -sf /usr/bin/pip${PY_VERSION} /usr/bin/pip${PY_MAJOR_VERSION}
    ln -sf /usr/bin/python${PY_MAJOR_VERSION} /usr/bin/python
    ln -sf /usr/bin/pip${PY_MAJOR_VERSION} /usr/bin/pip
}

# Parse arguments
if [ "$1" == "--download" ]; then
    download_python
elif [ "$1" == "--install" ]; then
    install_python
elif [ "$1" == "--create_links" ]; then
    create_links
else
    echo "Unexpected arguments, use '--download', '--install' or '--create_links' instead"
    exit 1
fi
