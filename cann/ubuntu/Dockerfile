ARG BASE_VERSION=latest
FROM ubuntu:${BASE_VERSION}

# arguments
ARG TARGETPLATFORM
ARG PY_VERSION
ARG CANN_CHIP
ARG CANN_VERSION

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
        curl \
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

# driver environment variable
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:${LD_LIBRARY_PATH}

WORKDIR /home
