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

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk add --no-cache \
        bash \
        curl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# Copy files
COPY ./cann.sh /tmp/cann.sh

# Download CANN
RUN chmod +x /tmp/cann.sh && \
    bash /tmp/cann.sh --download

# Phase 2: install CANN toolkit and kernels
FROM ubuntu:${BASE_VERSION} as installer

ARG PLATFORM
ARG CANN_CHIP
ARG CANN_VERSION

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
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
        python3 \
        python3-pip \
        python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

COPY --from=downloader /tmp /tmp

# Install CANN
RUN chmod +x /tmp/cann.sh && \
    bash /tmp/cann.sh --install && \
    rm -rf /tmp/*

# Phase 3:
FROM ubuntu:${BASE_VERSION} as official

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        bash \
        openssl \
        libblas3 \
        python3 \
        python3-pip \
        python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Copy files
COPY --from=installer /usr/local/Ascend /usr/local/Ascend
COPY --from=installer /etc/Ascend /etc/Ascend
COPY ./docker-entrypoint.sh /root/docker-entrypoint.sh

# Install python packages
RUN pip install --no-cache-dir attrs cython numpy decorator sympy cffi pyyaml pathlib2 psutil protobuf scipy requests absl-py \
    -i https://repo.huaweicloud.com/repository/pypi/simple

# Driver path
ENV DRIVER_PATH=/usr/local/Ascend/driver

# Add the driver path to the library path
ENV LD_LIBRARY_PATH=${DRIVER_PATH}/lib64/common/:${DRIVER_PATH}/lib64/driver/:${LD_LIBRARY_PATH}

ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
