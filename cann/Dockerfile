FROM ubuntu:20.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
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
    libblas3 && \
    apt remove -y cmake && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3.8.11
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /root/miniconda && \
    rm -f ~/miniconda.sh
RUN /root/miniconda/bin/conda create --name torch_npu -y python=3.8.11
ENV PATH=/root/miniconda/envs/torch_npu/bin/:$PATH

ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:$LD_LIBRARY_PATH \
    CANN_URL=https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C13SPC701/Ascend-cann-nnae_7.0.RC1.alpha001_linux-aarch64.run

RUN wget ${CANN_URL} && \
    chmod +x Ascend-cann-nnae_7.0.RC1.alpha001_linux-aarch64.run && \
    ./Ascend-cann-nnae_7.0.RC1.alpha001_linux-aarch64.run --install && \
    rm -f ./Ascend-cann-nnae_7.0.RC1.alpha001_linux-aarch64.run

# from /usr/local/Ascend/nnae/set_env.sh
ENV ASCEND_NNAE_HOME=/usr/local/Ascend/nnae/latest \
    LD_LIBRARY_PATH=${ASCEND_NNAE_HOME}/lib64:${ASCEND_NNAE_HOME}/lib64/plugin/opskernel:${ASCEND_NNAE_HOME}/lib64/plugin/nnengine:$LD_LIBRARY_PATH \
    PYTHONPATH=${ASCEND_NNAE_HOME}/python/site-packages:${ASCEND_NNAE_HOME}/opp/built-in/op_impl/ai_core/tbe:$PYTHONPATH \
    PATH=${ASCEND_NNAE_HOME}/bin:${ASCEND_NNAE_HOME}/compiler/ccec_compiler/bin:$PATH \
    ASCEND_AICPU_PATH=${ASCEND_NNAE_HOME} \
    ASCEND_OPP_PATH=${ASCEND_NNAE_HOME}/opp \
    ASCEND_HOME_PATH=${ASCEND_NNAE_HOME}
