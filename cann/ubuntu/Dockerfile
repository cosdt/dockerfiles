# Arguments
ARG BASE_VERSION=latest
ARG PY_VERSION=3.8

# Stage 0: Install Python
FROM ubuntu:${BASE_VERSION} AS py-installer

# Arguments
ARG PY_VERSION

# Environment variables
ENV PATH=/usr/local/python${PY_VERSION}/bin:${PATH}

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

# Download Python
RUN bash /tmp/python.sh --download

# Install Python
RUN bash /tmp/python.sh --install && \
    rm /tmp/python.sh

# Stage 1: Install CANN
FROM py-installer AS cann-installer

# Arguments
ARG PLATFORM=${TARGETPLATFORM}
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC2.alpha003

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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/cann.sh /tmp/cann.sh

# Download CANN
RUN bash /tmp/cann.sh --download

# Install CANN
RUN bash /tmp/cann.sh --install && \
    rm /tmp/cann.sh

# Stage 2: Copy results from previous stages
FROM ubuntu:${BASE_VERSION} AS official

# Arguments
ARG PY_VERSION

# Environment variables
ENV PY_HOME=/usr/local/python${PY_VERSION}
ENV ASCEND_HOME=/usr/local/Ascend
ENV PATH=${PY_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${ASCEND_HOME}/driver/lib64/common:${ASCEND_HOME}/driver/lib64/driver:${LD_LIBRARY_PATH}

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        bash \
        libc6 \
        libsqlite3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Copy files
COPY --from=cann-installer ${PY_HOME} ${PY_HOME}
COPY --from=cann-installer ${ASCEND_HOME} ${ASCEND_HOME}
COPY --from=cann-installer /etc/Ascend /etc/Ascend

# Set environment varibales
RUN \
    # Set environment variables for Python \
    PY_PATH="PATH=${PY_HOME}/bin:\${PATH}" && \
    echo "export ${PY_PATH}" >> /etc/profile && \
    echo "export ${PY_PATH}" >> ~/.bashrc && \
    # Set environment variables for CANN \
    CANN_TOOLKIT_ENV_FILE="${ASCEND_HOME}/ascend-toolkit/set_env.sh" && \
    DRIVER_LIBRARY_PATH="LD_LIBRARY_PATH=${ASCEND_HOME}/driver/lib64/common:${ASCEND_HOME}/driver/lib64/driver:\${LD_LIBRARY_PATH}" && \
    echo "export ${DRIVER_LIBRARY_PATH}" >> /etc/profile && \
    echo "export ${DRIVER_LIBRARY_PATH}" >> ~/.bashrc && \
    echo "source ${CANN_TOOLKIT_ENV_FILE}" >> /etc/profile && \
    echo "source ${CANN_TOOLKIT_ENV_FILE}" >> ~/.bashrc

ENTRYPOINT [ "/bin/bash", "-c", "source ${ASCEND_HOME}/ascend-toolkit/set_env.sh && exec \"$@\"", "--" ]
