ARG BASE_VERSION=latest
FROM openeuler/openeuler:${BASE_VERSION}

LABEL maintainer="Ascend Open Source <ascend@huawei.com>" \
      description="A Docker image for Ascend CANN"

# arguments
ARG TARGETPLATFORM
ARG PY_VERSION=3.8.0
ARG CANN_CHIP=910b
ARG CANN_VERSION=8.0.RC1

# change the default shell
SHELL [ "/bin/bash", "-c" ]

# install dependencies
RUN yum install -y \
        bc \
        wget \
        gcc \
        gcc-c++ \
        make \
        libtool \
        zlib \
        zlib-devel \
        bzip2 \
        bzip2-devel \
        pcre \
        sudo \
        libffi-devel \
        mesa-libGL \
        pcre-devel \
        pcre2-devel \
        perl-devel \
        perl-ExtUtils-Embed \
        openssl \
        openssl-devel \
        which \
        lzma \
        xz-devel \
        sqlite-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
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

WORKDIR /home
