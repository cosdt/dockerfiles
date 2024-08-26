# CANN Docker Image

## Usage

```docker
docker run \
    --name cann_container \
    --device /dev/davinci1 \
    --device /dev/davinci_manager \
    --device /dev/devmm_svm \
    --device /dev/hisi_hdc \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
    -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
    -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
    -v /etc/ascend_install.info:/etc/ascend_install.info \
    -it ascendai/cann:latest bash
```

## Build

In order to build CANN Docker images, ensure you have the following.

- Docker Engine 20.10+

Run in the root directory of the repository:

```docker
docker buildx bake -f docker-bake.hcl cann-prefer
```

To build single-arch images only:

```docker
docker buildx bake -f docker-bake.hcl --set '*.platform=linux/arm64' cann-prefer
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
docker buildx bake -f docker-bake.hcl cann-prefer
```

Don't have Bake? Use `docker buildx build` instead:

```docker
docker buildx build \
    -t ascendai/cann:latest \
    -f cann/ubuntu.Dockerfile \
    --build-arg BASE_VERSION=22.04 \
    --build-arg PY_VERSION=3.10 \
    --build-arg CANN_CHIP=910b \
    --build-arg CANN_VERSION=8.0.RC1 \
    cann/
```
