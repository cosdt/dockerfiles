# Arguments
ARG BASE_VERSION=latest
ARG PLATFORM=${TARGETPLATFORM}
ARG CANN_CHIP
ARG CANN_VERSION

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
        lapack-devel gcc-gfortran \
        python3-devel \
        python3-pip \
        wget \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Install CANN
RUN --mount=type=cache,from=downloader,target=/tmp,source=/tmp \
    umask 0022 && \
    chmod +x /tmp/cann.sh && \
    bash /tmp/cann.sh --install && \
    rm -rf /tmp/*

# Driver path
ENV DRIVER_PATH=/usr/local/Ascend/driver

# Add the driver path to the library path
ENV LD_LIBRARY_PATH=${DRIVER_PATH}/lib64/common/:${DRIVER_PATH}/lib64/driver/:${LD_LIBRARY_PATH}

# Add the driver path to /etc/enironment to make sure it can take effect
# when conntecting the container
ENTRYPOINT ["/bin/bash", "-c", "printenv | grep DRIVER_PATH >> /etc/environment && exec \"$@\"", "--"]
