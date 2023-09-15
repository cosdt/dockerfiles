# dockerfiles

## Usage

### 1. Ascend CANN image

Dockerhub: https://hub.docker.com/r/ascendai/cann

The Ascend CANN container images provide an easy-to-use distribution for CANN supported platforms.
```
$ docker run --rm --network host --name cann-on-ascend \
            --device /dev/davinci6:/dev/davinci6 \
            --device /dev/davinci_manager --device /dev/devmm_svm --device /dev/hisi_hdc \
            -v /usr/local/dcmi:/usr/local/dcmi -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
            -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
            -v /data/:/data/ 
            -ti ascendai/cann:910b-ubuntu2004 bash
$ npu-smi info
```

### 2. Ascend PyTorch image

Dockerhub: https://hub.docker.com/r/ascendai/pytorch

The Ascend PyTorch container images provide an easy-to-use distribution for PyTorch and Torch NPU on Ascend platform.
```
$ docker run --rm --network host --name pytorch-on-ascend \
            --device /dev/davinci6:/dev/davinci6 \
            --device /dev/davinci_manager --device /dev/devmm_svm --device /dev/hisi_hdc \
            -v /usr/local/dcmi:/usr/local/dcmi -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
            -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
            -v /data/:/data/ 
            -ti ascendai/pytorch:910b-ubuntu2004 bash
$ python3 -c "import torch;import torch_npu; a = torch.randn(3, 4).npu(); print(a + a);"
tensor([[-2.5684, -1.0355,  2.1467, -1.9409],
        [-0.8765, -2.1909,  1.6815,  2.1013],
        [ 7.0935,  3.7160,  1.6914, -0.1912]], device='npu:0')
```

### 3. Ascend LLM image

Dockerhub: https://hub.docker.com/r/ascendai/llm

The Ascend PyTorch container images provide an easy-to-use distribution for LLM related software stack.

```
$ docker run --rm --network host --name llm-on-ascend \
            --device /dev/davinci6:/dev/davinci6 \
            --device /dev/davinci_manager --device /dev/devmm_svm --device /dev/hisi_hdc \
            -v /usr/local/dcmi:/usr/local/dcmi -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
            -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
            -v /data/:/data/ 
            -ti ascendai/llm:910b-ubuntu2004 bash
$ python -m fastchat.serve.cli --model-path /opt/vicuna-13b-v1.5 --device npu --temperature 1e-6
```

## Build
### 1. For Ubuntu  based images

### ascendai/cann

```
docker build -t ascendai/cann:910b-ubuntu2004 -f ./cann/Dockerfile.ubuntu .
```

### ascendai/pytorch

```
docker build -t ascendai/pytorch:910b-ubuntu2004 -f ./pytorch/Dockerfile .
```

### ascendai/llm

```
cd llm
docker build -t ascendai/llm:910b-ubuntu2004 -f ./Dockerfile .
```

### 2. For openEuler based images

### ascendai/cann

```
docker build -t ascendai/cann:910b-openeuler2203sp2 -f ./cann/Dockerfile.openeuler .
```

### ascendai/pytorch

```
docker build -t ascendai/pytorch:910b-openeuler2203sp2 -f ./pytorch/Dockerfile --build-arg BASE_IMAGE=ascendai/cann:910b-openeuler2203sp2 .
```

### ascendai/llm

```
cd llm
docker build -t ascendai/llm:910b-openeuler2203sp2 -f ./Dockerfile --build-arg BASE_IMAGE=ascendai/pytorch:910b-openeuler2203sp2 .
```
