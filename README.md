# Ascend Docker Images

<p align="center">
    <a href="https://github.com/Ascend/dockerfiles/actions/workflows/docker.yml">
        <img src="https://github.com/Ascend/dockerfiles/actions/workflows/docker.yml/badge.svg" />
    </a>
    <a href="LICENSE">
        <img src="https://img.shields.io/github/license/Ascend/dockerfiles.svg" />
    </a>
    <img src="https://img.shields.io/github/v/release/Ascend/dockerfiles" />
    <img src="https://img.shields.io/badge/language-dockerfile-384D54.svg">
</p>

<p align="center">
    <a href="README_zh.md">
        <b>中文文档</b>
    </a> •
    <a href="https://hub.docker.com/u/ascendai">
        <b>Docker Hub</b>
    </a> •
    <a href="https://github.com/orgs/ascend/packages?ecosystem=container">
        <b>GitHub Container</b>
    </a> •
    <a href="https://quay.io/organization/ascend">
        <b>Red Hat Quay</b>
    </a>
</p>

We have several Docker images as following, you can find out details in 
their README.md:

- [Python](./python)
- [CANN](./cann)
- [PyTorch](./pytorch)
- [MindSpore](./mindspore)

## Build

In order to build Ascend Docker images, ensure you have the following.

- Docker Engine 20.10+

Run from the repository directory after cloning. All Ascend Docker images will
be built using [Docker Buildx Bake][1]. Please note that this process will
cost a lot of disk space.

[1]: https://docs.docker.com/build/bake/

```docker
docker buildx bake -f docker-bake.hcl
```

To build single-arch images only:

```docker
docker buildx bake -f docker-bake.hcl \
    --set '*.platform=linux/arm64'
```

To customize the registry and owner using JSON format:

```bash
export registries='
[
  {
    "url": "quay.io",
    "owner": "ascend"
  }
]'

docker buildx bake -f docker-bake.hcl
```

## License

This repository is licensed under the [Apache License 2.0](./LICENSE).
