# Torch-NPU Docker Image

## Usage

```docker
docker run \
    --name torch_container \
    --device /dev/davinci1 \
    --device /dev/davinci_manager \
    --device /dev/devmm_svm \
    --device /dev/hisi_hdc \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
    -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
    -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
    -v /etc/ascend_install.info:/etc/ascend_install.info \
    -it cosdt/pytorch:<TAG> bash
```

## Build

In order to build Torch-NPU Docker images, ensure you have the following.

- Docker Engine 20.10+

Run in the root directory of the repository:

```docker
docker buildx bake -f docker-bake.hcl pytorch-all
```

To build single-arch images only:

```docker
docker buildx bake -f docker-bake.hcl --set '*.platform=linux/arm64' pytorch-all
```

To customize the registry and owner using JSON format:

```bash
custom_registries='
[
  {
    "url": "quay.io",
    "owner": "cosdt"
  }
]'
registries="${custom_registries}" \
docker buildx bake -f docker-bake.hcl pytorch-all
```

Don't have Bake? Use `docker buildx build` instead:

```docker
docker buildx build \
    -t cosdt/pytorch:latest \
    -f pytorch/new.Dockerfile \
    --build-arg BASE_NAME=cosdt/cann \
    --build-arg BASE_VERSION=latest \
    --build-arg PYTORCH_VERSION=2.2.0 \
    --build-arg TORCH_NPU_VERSION=2.2.0 \
    pytorch/
```