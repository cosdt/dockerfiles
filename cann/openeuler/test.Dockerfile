# Arguments
ARG BASE_VERSION=latest
ARG PLATFORM=${TARGETPLATFORM}
ARG PY_VERSION=3.8
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC2.alpha002

# Phase 1: Install Miniconda
FROM openeuler/openeuler:${BASE_VERSION} as conda-installer

# Arguments
ARG PLATFORM
ARG PY_VERSION

# Environment variables
ENV PATH=/opt/miniconda/bin:${PATH}

# Install dependencies
RUN yum update -y && \
    yum install -y \
        gcc \
        gcc-c++ \
        make \
        cmake \
        zlib-devel \
        bzip2-devel \
        openssl-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Download Miniconda
RUN case ${PLATFORM} in \
         "linux/amd64")  MINICONDA_ARCH=x86_64  ;; \
         *)              MINICONDA_ARCH=aarch64   ;; \
    esac && \
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${MINICONDA_ARCH}.sh" && \
    # download \
    echo "Downloading Miniconda from ${MINICONDA_URL}" && \
    curl -fsSL -o /tmp/miniconda.sh "${MINICONDA_URL}"

# Install Miniconda to /opt/miniconda
RUN chmod +x /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -u -p /opt/miniconda && \
    rm -rf /tmp/miniconda.sh && \
    /opt/miniconda/bin/conda install -y python=${PY_VERSION} && \
    /opt/miniconda/bin/conda clean -ya

# Phase 2: Install CANN
FROM conda-installer as cann-installer

# Arguments
ARG PLATFORM
ARG CANN_CHIP
ARG CANN_VERSION

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

# Environment variables
ENV PATH=/opt/miniconda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:${LD_LIBRARY_PATH}

# Install dependencies
RUN yum update -y && \
    yum install -y \
        ca-certificates \
        bash \
        glibc \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Copy files
COPY --from=cann-installer /opt/miniconda /opt/miniconda
COPY --from=cann-installer /usr/local/Ascend /usr/local/Ascend
COPY --from=cann-installer /etc/Ascend /etc/Ascend

# Init conda environment
RUN /opt/miniconda/bin/conda init --all --system && \
    chmod 644 /etc/profile.d/conda.sh && \
    chmod -R 755 /opt/miniconda

# Set environment variables
RUN CANN_TOOLKIT_ENV_FILE="/usr/local/Ascend/ascend-toolkit/set_env.sh" && \
    DRIVER_LIBRARY_PATH="LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:\${LD_LIBRARY_PATH}" && \
    echo "export ${DRIVER_LIBRARY_PATH}" >> /etc/profile && \
    echo "export ${DRIVER_LIBRARY_PATH}" >> ~/.bashrc && \
    echo "source ${CANN_TOOLKIT_ENV_FILE}" >> /etc/profile && \
    echo "source ${CANN_TOOLKIT_ENV_FILE}" >> ~/.bashrc

ENTRYPOINT [ "/bin/bash", "-c", "source /usr/local/Ascend/ascend-toolkit/set_env.sh && exec \"$@\"", "--" ]
