# Phase 1
FROM alpine AS builder

# install dependencies
RUN apk add --no-cache wget && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    wget https://raw.githubusercontent.com/cosdt/dockerfiles/ascend-1/scripts/install-cann.sh -q -O /tmp/install-cann.sh && \
    wget https://raw.githubusercontent.com/cosdt/dockerfiles/ascend-1/scripts/install-miniconda.sh -q -O /tmp/install-miniconda.sh

# Phase 2
ARG BASE_VERSION=latest
FROM openeuler:$BASE_VERSION

LABEL maintainer="Ascend Open Source <ascend@huawei.com>" \
      description="A Docker image for Ascend CANN"

# arguments
ARG PLATFORM=linux/arm64
ARG CANN_HOME=/usr/local/Ascend
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC1

# timezone
ENV TIME_ZONE=Asia/Shanghai

# install dependies
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && yum install -y \
         git \
         wget \
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
         python3-devel \
         util-linux \
         patchelf \
    && yum clean all \
    && rm -rf /var/cache/yum

# install pkages
COPY --from=builder /tmp /tmp

RUN # install miniconda && \
    PLATFORM="$PLATFORM" \
    CONDA_HOME="/opt/miniconda" \
    bash +x /tmp/install-miniconda.sh && \
    # install cann && \
    PLATFORM="$PLATFORM" \
    CANN_HOME="$CANN_HOME" \
    CANN_CHIP="$CANN_CHIP" \
    CANN_VERSION="$CANN_VERSION" \
    bash +x /tmp/install-cann.sh && \
    # clean
    rm -rf /tmp/*

WORKDIR /home
