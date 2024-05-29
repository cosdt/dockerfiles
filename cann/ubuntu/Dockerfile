# todo arg
FROM ubuntu:22.04

LABEL maintainer="Ascend Open Source <ascend@huawei.com>" \
      description="A Docker image for Ascend CANN"

# arguments
ARG BASE_VERSION=latest
ARG PLATFORM=linux/arm64
ARG PY_VERSION=3.9.0
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC1

# change the default shell
SHELL [ "/bin/bash", "-c" ]

# set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# install dependies
RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        bash \
        git \
        wget \
        gcc \
        g++ \
        make \
        cmake \
        zlib1g \
        zlib1g-dev \
        openssl \
        libsqlite3-dev \
        libssl-dev \
        libffi-dev \
        unzip \
        pciutils \
        net-tools \
        libblas-dev \
        gfortran \
        patchelf \
        libblas3 \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* \
     && rm -rf /var/tmp/* \
     && rm -rf /tmp/*

# copy files
COPY . /tmp

# install python
RUN bash +x /tmp/install-py.sh

RUN python -c "import sys; print(sys.version)"

# install cann toolkit and kernel
RUN \
    chmod +x /tmp/install-cann.sh && \
    PLATFORM="$PLATFORM" \
    CANN_CHIP="$CANN_CHIP" \
    CANN_VERSION="$CANN_VERSION" \
    source /tmp/install-cann.sh && \
    # clean up \
    rm -rf /tmp/*

WORKDIR /home
