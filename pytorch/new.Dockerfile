ARG BASE_NAME=quay.io/ascend/cann
ARG BASE_VERSION=latest

FROM ${BASE_NAME}:${BASE_VERSION} as official

# Arguments
ARG PYTORCH_VERSION
ARG TORCH_NPU_VERSION

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install PyTorch and Torch-NPU
RUN pip install --no-cache-dir torch==${PYTORCH_VERSION} --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir torch-npu==${TORCH_NPU_VERSION}
