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
RUN yum update -y && \
    yum install -y \
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
        util-linux \
        findutils \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Copy files
COPY ../scripts/cann.sh /tmp/cann.sh

# Download CANN
RUN bash /tmp/cann.sh --download

# Install CANN
RUN bash /tmp/cann.sh --install && \
    rm /tmp/cann.sh

# Stage 2: Copy results from previous stages
FROM openeuler/openeuler:${BASE_VERSION} AS official

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
