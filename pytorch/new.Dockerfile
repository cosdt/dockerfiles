ARG BASE_NAME=ubuntu
ARG BASE_VERSION=latest
FROM ${BASE_NAME}:${BASE_VERSION} as builder

# Arguments
ARG PYTORCH_VERSION
ARG TORCH_NPU_VERSION

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install PyTorch
RUN pip3 install --no-cache-dir \
        torch==${PYTORCH_VERSION} \
        torch_npu==${TORCH_NPU_VERSION}
