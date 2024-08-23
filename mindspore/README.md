# Mindspore Docker Image

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
    -it ascendai/mindspore:latest bash
```

## Build

In order to build Torch-NPU Docker images, ensure you have the following.

- Docker Engine 20.10+

Run in the root directory of the repository:

```docker
docker buildx bake -f docker-bake.hcl mindspore-all
```

To build single-arch images only:

```docker
docker buildx bake -f docker-bake.hcl --set '*.platform=linux/arm64' mindspore-all
```

To customize the registry and owner using JSON format:

```bash
custom_registries='
[
  {
    "url": "quay.io",
    "owner": "ascend"
  }
]'
registries="${custom_registries}" \
docker buildx bake -f docker-bake.hcl mindspore-all
```

Don't have Bake? Use `docker buildx build` instead:

```docker
docker buildx build \
    -t ascendai/mindspore:latest \
    -f mindspore/Dockerfile \
    --build-arg BASE_NAME=ascendai/cann \
    --build-arg BASE_VERSION=latest \
    --build-arg MINDSPORE_VERSION=2.3.0rc1\
    pytorch/
```
