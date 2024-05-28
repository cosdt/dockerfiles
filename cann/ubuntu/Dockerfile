# Phase 1
FROM alpine AS builder

# install dependencies
RUN apk update && \
    apk add --no-cache wget && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    wget https://raw.githubusercontent.com/cosdt/dockerfiles/ascend-1/scripts/install-cann.sh -q -O /tmp/install-cann.sh && \
    wget https://raw.githubusercontent.com/cosdt/dockerfiles/ascend-1/scripts/install-miniconda.sh -q -O /tmp/install-miniconda.sh

# Phase 2
# todo arg
FROM ubuntu:22.04

LABEL maintainer="Ascend Open Source <ascend@huawei.com>" \
      description="A Docker image for Ascend CANN"

# arguments
ARG BASE_VERSION=latest
ARG PLATFORM=linux/arm64
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC1

# timezone
ENV TIME_ZONE=Asia/Shanghai

# avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# change the default shell
SHELL ["/bin/bash", "-c"]

# install dependies
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
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

# install pkages
COPY --from=builder /tmp /tmp

RUN \
    # install miniconda \
    chmod +x /tmp/install-miniconda.sh && \
    PLATFORM="$PLATFORM" \
    CONDA_HOME="/opt/miniconda" \
    source /tmp/install-miniconda.sh && \
    # clean up \
    rm -f /tmp/install-miniconda.sh

RUN source /root/.bashrc && \
    echo "$HOME" && \
    cat /root/.bashrc && \
    conda --version && \
    python -c "print(__version__)"

RUN \
    # install cann \
    chmod +x /tmp/install-cann.sh && \
    PLATFORM="$PLATFORM" \
    CANN_CHIP="$CANN_CHIP" \
    CANN_VERSION="$CANN_VERSION" \
    source /tmp/install-cann.sh && \
    # clean up \
    rm -f /tmp/install-cann.sh

WORKDIR /home
