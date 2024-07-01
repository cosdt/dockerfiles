# Arguments
ARG BASE_VERSION=latest
ARG PLATFORM=${TARGETPLATFORM}
ARG PY_VERSION=3.8
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC2.alpha002

# Phase 1: Install python
FROM openeuler/openeuler:${BASE_VERSION} as py-installer

# Arguments
ARG PY_VERSION

# Install dependencies
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
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
RUN yum install -y \
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
        curl \
        bzip2-devel \
        ncurses-devel \
        gdbm-devel \
        readline-devel \
        xz-devel \
        tk-devel \
        libuuid-devel \
        libnsl2-devel \
        findutils \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/cann.sh /tmp/cann.sh

# Install CANN
RUN bash /tmp/cann.sh --install && \
    rm /tmp/cann.sh

# Phase 3: Copy results from previous phases
FROM openeuler/openeuler:${BASE_VERSION} as official

# Arguments
ARG PLATFORM
ARG PY_VERSION
ARG CANN_CHIP
ARG CANN_VERSION

# Install dependencies
RUN yum install -y \
        ca-certificates \
        bash \
        glibc \
    && yum clean all \
    && rm -rf /var/cache/yum \
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
