#!/bin/bash

set -e

PY_VERSION=${PY_VERSION:-"3.8.0"}
PY_MAJOR_VERSION=$(echo $PY_VERSION | cut -d'.' -f1)
PY_MINOR_VERSION=$(echo $PY_VERSION | cut -d'.' -f2)
PY_SHORT_VERSION="${PY_MAJOR_VERSION}.${PY_MINOR_VERSION}"

PY_HOME="/usr/local/python${PY_VERSION}"
PY_INSTALLER_TAR="Python-${PY_VERSION}.tgz"
PY_INSTALLER_DIR="Python-${PY_VERSION}"
PY_INSTALLER_URL="https://repo.huaweicloud.com/python/${PY_VERSION}/${PY_INSTALLER_TAR}"

# download python
echo "Downloading ${PY_INSTALLER_TAR}"
wget ${PY_INSTALLER_URL} -q -O /tmp/${PY_INSTALLER_TAR}
tar -xf /tmp/$PY_INSTALLER_TAR -C /tmp

# install python
echo "Installing ${PY_INSTALLER_DIR}"
cd /tmp/${PY_INSTALLER_DIR}
./configure --prefix=${PY_HOME} --enable-shared LDFLAGS="-Wl,-rpath ${PY_HOME}/lib"
make -j$(nproc)
make altinstall

# create links
ln -sf ${PY_HOME}/bin/python${PY_SHORT_VERSION} /usr/bin/python${PY_MAJOR_VERSION}
ln -sf ${PY_HOME}/bin/pip${PY_SHORT_VERSION} /usr/bin/pip${PY_MAJOR_VERSION}
ln -sf /usr/bin/python${PY_MAJOR_VERSION} /usr/bin/python
ln -sf /usr/bin/pip${PY_MAJOR_VERSION} /usr/bin/pip

# clean up
rm -rf /tmp/${PY_INSTALLER_TAR} /tmp/${PY_INSTALLER_DIR}

echo "Python ${PY_VERSION} installation successful."
python -c "import sys; print(sys.version)"
