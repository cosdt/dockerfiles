ARG BASE_IMAGE=ascendai/pytorch:ubuntu2004
FROM ${BASE_IMAGE}

COPY fastchat_npu.patch ./

RUN git clone https://github.com/lm-sys/FastChat.git && \
    cd FastChat && \
    git checkout e4758da20dae96486fceb0cce24e5107c4cfc2eb && \
    git apply ../fastchat_npu.patch && \
    pip install -e ".[model_worker,webui]" -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir transformers==4.32.1 -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir accelerate==0.22.0 -i https://pypi.tuna.tsinghua.edu.cn/simple
