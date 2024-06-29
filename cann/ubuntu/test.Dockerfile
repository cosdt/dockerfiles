# Arguments
ARG BASE_VERSION=latest
FROM ubuntu:${BASE_VERSION} as installer

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
        curl \
        build-essential \
        libbz2-dev \
        libncurses5-dev \
        libnss3-dev \
        libgdbm-dev \
        libreadline-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/install-py.sh /tmp/install-py.sh

# Install Python
RUN chmod +x /tmp/install-py.sh && \
    bash /tmp/install-py.sh

RUN pip install pyyaml -i https://pypi.tuna.tsinghua.edu.cn/simple

FROM ubuntu:${BASE_VERSION} as official

# Install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        bash \
        libc6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

COPY --from=installer /usr/local/python3.8 /usr/local/python3.8
COPY ../scripts/cann.sh /tmp/cann.sh

RUN ln -sf /usr/local/python3.8/bin/python3.8 /usr/bin/python && \
    ln -sf /usr/local/python3.8/bin/pip3.8 /usr/bin/pip
