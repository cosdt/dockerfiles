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
    -v /etc/ascend_install.info:/etc/ascend_install.info \
    -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
    -it cosdt/cann:<TAG> bash
```

## Build

In order to build CANN Docker images, ensure you have the following.

- Docker Engine 20.10+

Run in the root directory of the repository:

```docker
docker buildx bake -f docker-bake.hcl cann
```

To build single-arch images only:

```docker
docker buildx bake -f docker-bake.hcl --set '*.platform=linux/arm64' cann
```

To customize the registry and owner:

```docker
registry=ghcr.io \
owner=your_gh_username \
docker buildx bake -f docker-bake.hcl cann
```

Don't have Bake? Use `docker build` instead:

```docker
docker build -t cann:<TAG> -f cann/ubuntu/Dockerfile cann/
```
