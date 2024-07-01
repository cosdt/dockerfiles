# Arguments
ARG BASE_VERSION=latest
ARG PLATFORM=${TARGETPLATFORM}
ARG PY_VERSION=3.8
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC2.alpha002

# Phase 1: Install python
FROM ubuntu:${BASE_VERSION} as py-installer

# Arguments
ARG PY_VERSION

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        bash \
        curl \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libncurses5-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        libnss3-dev \
        libgdbm-dev \
        liblzma-dev \
        libev-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/python.sh /tmp/python.sh

# Install Python
RUN bash /tmp/python.sh --install && \
    rm /tmp/python.sh

# Phase 2: Install CANN
FROM py-installer as cann-installer

# Arguments
ARG PLATFORM
ARG CANN_CHIP
ARG CANN_VERSION

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
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

# Copy files
COPY ../scripts/cann.sh /tmp/cann.sh

# Install CANN
RUN bash /tmp/cann.sh --install && \
    rm /tmp/cann.sh

# Phase 3: Copy results from previous phases
FROM ubuntu:${BASE_VERSION} as official

# Arguments
ARG PLATFORM
ARG PY_VERSION
ARG CANN_CHIP
ARG CANN_VERSION

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        bash \
        libc6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Copy files
COPY --from=cann-installer /usr/local/python${PY_VERSION} /usr/local/python${PY_VERSION}
COPY --from=cann-installer /usr/local/Ascend /usr/local/Ascend
COPY --from=cann-installer /etc/Ascend /etc/Ascend
COPY ../scripts /root/scripts

# Create symbolic links
RUN /root/scripts/python.sh --create_links && \
    rm /root/scripts/python.sh

# Set environment variables
RUN /root/scripts/cann.sh --set_env && \
    rm /root/scripts/cann.sh

# Add the driver path to the library path
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:${LD_LIBRARY_PATH}

ENTRYPOINT [ "/root/scripts/docker-entrypoint.sh" ]
