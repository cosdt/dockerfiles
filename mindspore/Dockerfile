ARG BASE_NAME=cosdt/cann
ARG BASE_VERSION=latest
FROM ${BASE_NAME}:${BASE_VERSION} as official

# Arguments
ARG MINDSPORE_VERSION=2.2.0

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install mindspore
RUN pip install --no-cache-dir \
        mindspore==${MINDSPORE_VERSION}
