# Arguments
ARG BASE_VERSION=latest
ARG PY_VERSION=3.8

# Stage 1: Install CANN
FROM ascendai/python:${PY_VERSION}-ubuntu${BASE_VERSION} AS cann-installer

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
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

COPY ./cann.sh /tmp/cann.sh
RUN bash /tmp/cann.sh --download
RUN bash /tmp/cann.sh --install

# Stage 2: Copy results from previous stages
FROM ubuntu:${BASE_VERSION} AS official

# Arguments
ARG PY_VERSION

# Environment variables
ENV PATH=/usr/local/python${PY_VERSION}/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common:/usr/local/Ascend/driver/lib64/driver:${LD_LIBRARY_PATH}

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
COPY --from=cann-installer /usr/local/python${PY_VERSION} /usr/local/python${PY_VERSION}
COPY --from=cann-installer /usr/local/Ascend /usr/local/Ascend
COPY --from=cann-installer /etc/Ascend /etc/Ascend

# Set environment variables
RUN \
    # Set environment variables for Python \
    PY_PATH="PATH=/usr/local/python${PY_VERSION}/bin:\${PATH}" && \
    echo "export ${PY_PATH}" >> /etc/profile && \
    echo "export ${PY_PATH}" >> ~/.bashrc && \
    # Set environment variables for CANN \
    CANN_TOOLKIT_ENV_FILE="/usr/local/Ascend/ascend-toolkit/set_env.sh" && \
    DRIVER_LIBRARY_PATH="LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common:/usr/local/Ascend/driver/lib64/driver:\${LD_LIBRARY_PATH}" && \
    echo "export ${DRIVER_LIBRARY_PATH}" >> /etc/profile && \
    echo "export ${DRIVER_LIBRARY_PATH}" >> ~/.bashrc && \
    echo "source ${CANN_TOOLKIT_ENV_FILE}" >> /etc/profile && \
    echo "source ${CANN_TOOLKIT_ENV_FILE}" >> ~/.bashrc

ENTRYPOINT [ "/bin/bash", "-c", "source /usr/local/Ascend/ascend-toolkit/set_env.sh && exec \"$@\"", "--" ]
