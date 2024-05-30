ARG BASE_VERSION=latest
FROM ubuntu:${BASE_VERSION}

LABEL maintainer="Ascend Open Source <ascend@huawei.com>" \
      description="A Docker image for Ascend CANN"

# arguments
ARG TARGETPLATFORM
ARG PY_VERSION=3.8.0
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC1

# change the default shell
SHELL [ "/bin/bash", "-c" ]

# set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update \
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
        vim \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* \
     && rm -rf /var/tmp/* \
     && rm -rf /tmp/*

# copy files
COPY ../scripts /root/scripts

# install python
RUN chmod +x /root/scripts/install-py.sh && \
    bash /root/scripts/install-py.sh && \
    rm -rf /root/scripts/install-py.sh /tmp/*

# install cann toolkit and kernel
RUN chmod +x /root/scripts/install-cann.sh && \
    PLATFORM=${TARGETPLATFORM} bash /root/scripts/install-cann.sh && \
    rm -rf /root/scripts/install-cann.sh /tmp/*

WORKDIR /home
