ARG BASE_IMAGE=ascendai/pytorch:910b-ubuntu2004
FROM ${BASE_IMAGE}

COPY fastchat_npu.patch ./

RUN git clone https://github.com/lm-sys/FastChat.git && \
    cd FastChat && \
    git checkout ce3311d086055d3c4d104573b64d71e67cd613b6 && \
    git apply ../fastchat_npu.patch && \
    pip install -e ".[model_worker,webui]" -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir transformers==4.32.1 -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir accelerate==0.22.0 -i https://pypi.tuna.tsinghua.edu.cn/simple
