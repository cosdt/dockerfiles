# Arguments
ARG BASE_VERSION=latest
ARG PY_VERSION=3.8

# Stage 0: Install Python
FROM openeuler/openeuler:${BASE_VERSION} AS py-installer

# Arguments
ARG PY_VERSION

# Environment variables
ENV PATH=/usr/local/python${PY_VERSION}/bin:${PATH}

# Install dependencies
RUN yum update -y && \
    yum install -y \
        gcc \
        gcc-c++ \
        make \
        cmake \
        curl \
        zlib-devel \
        bzip2-devel \
        openssl-devel \
        ncurses-devel \
        sqlite-devel \
        readline-devel \
        tk-devel \
        gdbm-devel \
        libpcap-devel \
        xz-devel \
        libev-devel \
        expat-devel \
        libffi-devel \
        systemtap-sdt-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Copy files
COPY ./python.sh /tmp/python.sh

# Download Python
RUN bash /tmp/python.sh --download

# Install Python
RUN bash /tmp/python.sh --install && \
    rm /tmp/python.sh

# Stage 1: Copy results from previous stages
FROM openeuler/openeuler:${BASE_VERSION} AS official

# Arguments
ARG PY_VERSION

# Environment variables
ENV PATH=/usr/local/python${PY_VERSION}/bin:${PATH}

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install dependencies
RUN yum update -y && \
    yum install -y \
        ca-certificates \
        bash \
        glibc \
        sqlite-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Copy files
COPY --from=py-installer /usr/local/python${PY_VERSION} /usr/local/python${PY_VERSION}

# Set environment variables
RUN \
    # Set environment variables for Python \
    PY_PATH="PATH=/usr/local/python${PY_VERSION}/bin:\${PATH}" && \
    echo "export ${PY_PATH}" >> /etc/profile && \
    echo "export ${PY_PATH}" >> ~/.bashrc
