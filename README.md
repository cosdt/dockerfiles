# dockerfiles

## PyTorch Torch_npu and CANN Version Matching Table

### Stable Version

Based on docker iamges of CANN provided by below, you can install torch and torch_npu by pip directly, without extra operations.

| PyTorch  | Torch_npu  | CANN Version(Docker Images) |
| :---: | :---: | :---: |
| 2.1.0 | torch_npu-2.1.0rc1 | [7.0.RC1.alpha005-openeuler2203sp2](https://hub.docker.com/r/ascendai/cann/tags) |
| 2.1.0 | torch_npu-2.1.0 | [7.0.0.alpha003-openeuler2203sp2](https://hub.docker.com/r/ascendai/cann/tags) |

Take **torch_npu-2.1.0** as example:

```Shell
# pull the iamge first.
$ docker pull ascendai/cann:7.0.0.alpha003-openeuler2203sp2

# create the container
# modify the parameters marked in bold according to the actual situation.
$ docker run --rm --network host --name cann \
            --device /dev/davinci6:/dev/davinci6 \
            --device /dev/davinci_manager --device /dev/devmm_svm --device /dev/hisi_hdc \
            -v /usr/local/dcmi:/usr/local/dcmi -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
            -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
            -v /data/:/data/ 
            -ti ascendai/cann:7.0.0.alpha003-openeuler2203sp2 bash

# Now, we are in Docker
# install both torch and torch_npu
$ pip3 install torch=2.1.0
$ pip3 install torch_npu=2.1.0

# try it
$ python3 -c "import torch;import torch_npu; a = torch.randn(3, 4).npu(); print(a + a);"
tensor([[-2.5684, -1.0355,  2.1467, -1.9409],
        [-0.8765, -2.1909,  1.6815,  2.1013],
        [ 7.0935,  3.7160,  1.6914, -0.1912]], device='npu:0')
```

## Develop Version

If you want to contribute to torch_npu or experience the latest features about both torch and torch_npu, you MUST need to use cann version provided below and alse need to build both torch and torch_npu manually.

| PyTorch  | Torch_npu  | CANN Version(Docker Images) |
| :---: | :---: | :---: |
| [main](https://github.com/pytorch/pytorch/tree/main) | [master](https://github.com/Ascend/pytorch/tree/master) | [7.1-openeuler2203sp2](https://hub.docker.com/r/ascendai/cann/tags) |

Refer to the instructions below.

```Shell
# pull the iamge first.
$ docker pull ascendai/cann:7.1-openeuler2203sp2

# create the container
# modify the parameters marked in bold according to the actual situation.
$ docker run --rm --network host --name cann \
            --device /dev/davinci6:/dev/davinci6 \
            --device /dev/davinci_manager --device /dev/devmm_svm --device /dev/hisi_hdc \
            -v /usr/local/dcmi:/usr/local/dcmi -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
            -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
            -v /data/:/data/ 
            -ti ascendai/cann:7.1-openeuler2203sp2 bash

# install torch
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
export _GLIBCXX_USE_CXX11_ABI=0
export USE_CUDA=0
export USE_XNNPACK=0
python setup.py develop

# install torch_npu
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
bash ci/build.sh --python=3.8
pip3 install dist/torch_npu*.whl

# try it
$ python3 -c "import torch;import torch_npu; a = torch.randn(3, 4).npu(); print(a + a);"
tensor([[-2.5684, -1.0355,  2.1467, -1.9409],
        [-0.8765, -2.1909,  1.6815,  2.1013],
        [ 7.0935,  3.7160,  1.6914, -0.1912]], device='npu:0')
```

### Usage

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
            -ti ascendai/cann:ubuntu2004 bash
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
            -ti ascendai/pytorch:ubuntu2004 bash
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
            -ti ascendai/llm:ubuntu2004 bash
$ python -m fastchat.serve.cli --model-path /opt/vicuna-13b-v1.5 --device npu --temperature 1e-6
```

## Build
### 1. For Ubuntu  based images

### ascendai/cann

```
docker build -t ascendai/cann:ubuntu2004 -f ./cann/Dockerfile.ubuntu .
```

### ascendai/pytorch

```
docker build -t ascendai/pytorch:ubuntu2004 -f ./pytorch/Dockerfile .
```

### ascendai/llm

```
cd llm
docker build -t ascendai/llm:ubuntu2004 -f ./Dockerfile .
```

### 2. For openEuler based images

### ascendai/cann

```
docker build -t ascendai/cann:openeuler2203sp2 -f ./cann/Dockerfile.openeuler .
```

### ascendai/pytorch

```
docker build -t ascendai/pytorch:openeuler2203sp2 -f ./pytorch/Dockerfile --build-arg BASE_IMAGE=ascendai/cann:openeuler2203sp2 .
```

### ascendai/llm

```
cd llm
docker build -t ascendai/llm:openeuler2203sp2 -f ./Dockerfile --build-arg BASE_IMAGE=ascendai/pytorch:openeuler2203sp2 .
```
