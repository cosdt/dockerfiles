FROM $BASE:$BASE_VERSION

ARG BASE_IMAGE
ARG BASE_VERSION

LABEL maintainer="Ascend Open Source <ascend@huawei.com>" \
      description="A Docker image for Ascend CANN"

# arguments
ARG PLATFORM=linux/arm64

# timezone
ENV TIME_ZONE=Asia/Shanghai

# avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# copy files
COPY scripts /root/scripts

# install dependies
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && apt-get update \
    && apt-get install -y \
        wget \
        curl \
        bzip2 \
        sudo \
        openssh-server \
        apt-transport-https \
        ca-certificates \
        git \
        g++ \
        gcc \
        cmake \
        vim \
        jq \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* \
     && rm -rf /tmp/* \
     && rm -rf /var/tmp/*

# install miniconda to /opt/miniconda
RUN PLATFORM="$PLATFORM" CONDA_HOME="/opt/miniconda" bash /root/scripts/install-miniconda.sh

WORKDIR /home

ENTRYPOINT ["/root/scripts/docker-entrypoint.sh"]
