# Python Docker Image

## Usage

```docker
docker run --rm -it ascendai/python:latest \
    python -c "import sys; print(sys.version)"
```

## Build

In order to build Python Docker images, ensure you have the following.

- Docker Engine 20.10+

Run in the root directory of the repository:

```docker
docker buildx bake -f docker-bake.hcl python
```

Don't have Bake? Use `docker buildx build` instead:

```docker
docker buildx build \
    -t ascendai/python:latest \
    -f python/ubuntu.Dockerfile \
    --build-arg BASE_VERSION=22.04 \
    --build-arg PY_VERSION=3.10 \
    python/
```
