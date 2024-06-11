ARG BASE_VERSION=latest

# Phase 1: download CANN installers
FROM alpine as downloader

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache \
        bash \
        wget \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/cann.sh /tmp/cann.sh

# Download CANN
RUN chmod +x /tmp/cann.sh && \
    PLATFORM=${TARGETPLATFORM} bash /tmp/cann.sh --download

# Phase 2: install CANN toolkit and kernels
FROM openeuler/openeuler:${BASE_VERSION} as builder

# Arguments
ARG TARGETPLATFORM
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

# Copy files
COPY --from=downloader /tmp /tmp

# Install CANN
RUN chmod +x /tmp/cann.sh && \
    PLATFORM=${TARGETPLATFORM} bash /tmp/cann.sh --install && \
    rm -rf /tmp/*

# Set environment variables
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:${LD_LIBRARY_PATH}

WORKDIR /home
