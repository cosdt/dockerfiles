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
FROM ubuntu:${BASE_VERSION} as builder

ARG PLATFORM
ARG CANN_CHIP
ARG CANN_VERSION

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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
        python3 \
        python3-pip \
        python3-dev \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Install CANN
RUN --mount=type=cache,from=downloader,target=/tmp,source=/tmp \
    umask 0022 && \
    chmod +x /tmp/cann.sh && \
    bash /tmp/cann.sh --install && \
    rm -rf /tmp/*

WORKDIR /home
