# Arguments
ARG BASE_VERSION=latest
ARG PLATFORM=${TARGETPLATFORM}

# Phase 1: Install python
FROM openeuler/openeuler:${BASE_VERSION} as py-installer

# Install dependencies
RUN yum update \
    && yum install -y \
        zlib-devel \
        bzip2-devel \
        openssl-devel \
        ncurses-devel \
        sqlite-devel \
        readline-devel \
        tk-devel \
        gdbm-devel \
        db4-devel \
        libpcap-devel \
        xz-devel \
        expat-devel \
        libffi-devel \
        systemtap-sdt-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/python.sh /tmp/python.sh

# Install Python
RUN bash /tmp/python.sh --install && \
    rm /tmp/python.sh
