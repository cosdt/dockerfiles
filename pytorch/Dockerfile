ARG BASE_IMAGE=ascendai/cann:ubuntu2004
FROM ${BASE_IMAGE}

RUN pip install --no-cache-dir cmake ninja -i https://repo.huaweicloud.com/repository/pypi/simple

# Replace below commands with `pip install torch>=2.1.0` after PyTorch 2.1.0 release.
RUN git clone https://github.com/pytorch/pytorch.git && \
    cd pytorch && \
    git reset 5913437a40a6e45ab7e164afb7c6ec930dd40b2f --hard && \
    git cherry-pick 68cb854d734 || \
    cp aten/src/ATen/native/CPUFallback.cpp ../ && \
    git cherry-pick --abort && \
    mv ../CPUFallback.cpp aten/src/ATen/native/CPUFallback.cpp && \
    pip install --no-cache-dir -r ./requirements.txt -i https://repo.huaweicloud.com/repository/pypi/simple && \
    export USE_CUDA=0 && \
    export USE_XNNPACK=0 && \
    python3 setup.py develop

# Replace below commands with `pip install torch_npu` after PyTorch 2.1.0 release.
RUN git clone https://github.com/ascend/pytorch.git ascend-pytorch && \
    cd ascend-pytorch && \
    git reset 81ece7b664adc28e698044d0e9091d39a1a6dfa6 --hard && \
    pip install --no-cache-dir pyyaml wheel decorator snippy && \
    bash ci/build.sh --python=3.8 && \
    pip3 install --upgrade dist/torch_npu-2.1.0-cp38-cp38-linux_aarch64.whl && \
    cd .. && rm -rf ascend-pytorch

RUN pip install --no-cache-dir protobuf==3.20.0 attrs cython numpy decorator sympy cffi pyyaml pathlib2 psutil scipy requests absl-py
