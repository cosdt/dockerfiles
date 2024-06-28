# Arguments
ARG BASE_VERSION=latest
ARG PLATFORM=${TARGETPLATFORM}

# Phase 1: download CANN installers
FROM alpine as downloader

ARG PLATFORM
ARG CANN_CHIP
ARG CANN_VERSION

RUN apk add --no-cache \
        bash \
        curl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/cann.sh /tmp/cann.sh
COPY ../scripts/install-py.sh /tmp/install-py.sh

# Download CANN
RUN chmod +x /tmp/cann.sh && \
    bash /tmp/cann.sh --download

# Phase 2: install CANN toolkit and kernels
FROM openeuler/openeuler:${BASE_VERSION} as builder

ARG PLATFORM
ARG CANN_CHIP
ARG CANN_VERSION

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

RUN yum install -y \
        gcc \
        gcc-c++ \
        make \
        cmake \
        unzip \
        zlib-devel \
        libffi-devel \
        openssl-devel \
        pciutils \
        net-tools \
        sqlite-devel \
        lapack-devel \
        gcc-gfortran \
        curl \
        bzip2-devel \
        ncurses-devel \
        gdbm-devel \
        readline-devel \
        xz-devel \
        tk-devel \
        libuuid-devel \
        libnsl2-devel \
        findutils \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Install Python
RUN --mount=type=cache,from=downloader,target=/tmp,source=/tmp \
    umask 0022 && \
    chmod +x /tmp/install-py.sh && \
    bash /tmp/install-py.sh

# Install CANN
RUN --mount=type=cache,from=downloader,target=/tmp,source=/tmp \
    umask 0022 && \
    chmod +x /tmp/cann.sh && \
    bash /tmp/cann.sh --install

# Copy files
COPY ../scripts/docker-entrypoint.sh /root/docker-entrypoint.sh

# Driver path
ENV DRIVER_PATH=/usr/local/Ascend/driver

# Add the driver path to the library path
ENV LD_LIBRARY_PATH=${DRIVER_PATH}/lib64/common/:${DRIVER_PATH}/lib64/driver/:${LD_LIBRARY_PATH}

ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
