# Ascend Docker Images

<p align="center">
    <a href="https://github.com/cosdt/dockerfiles/actions/workflows/docker.yml">
        <img src="https://github.com/cosdt/dockerfiles/actions/workflows/docker.yml/badge.svg" />
    </a>
    <a href="LICENSE">
        <img src="https://img.shields.io/github/license/cosdt/dockerfiles.svg" />
    </a>
    <img src="https://img.shields.io/github/v/release/cosdt/dockerfiles" />
    <img src="https://img.shields.io/badge/language-dockerfile-384D54.svg">
</p>

<p align="center">
    <a href="README_zh.md">
        <b>中文文档</b>
    </a> •
    <a href="https://hub.docker.com/u/cosdt">
        <b>Docker Hub</b>
    </a> •
    <a href="https://github.com/orgs/cosdt/packages?ecosystem=docker">
        <b>GitHub Container</b>
    </a> •
    <a href="https://quay.io/organization/cosdt">
        <b>Red Hat Quay</b>
    </a>
</p>

## Build

See: https://ascend.github.io/docs/sources/ascend/quick_install.html

In order to build Ascend Docker images, ensure you have the following.

- Docker Engine 20.10+

In the root repository, run:

```docker
docker buildx bake -f docker-bake.hcl
```

To build single-arch images only:

```docker
docker buildx bake -f docker-bake.hcl --set '*.platform=linux/arm64'
```

To customize the registry and owner:

```docker
registry=ghcr.io \
owner=your_gh_username \
docker buildx bake -f docker-bake.hcl
```

## License

This repository is licensed under the [Apache License 2.0](./LICENSE).
