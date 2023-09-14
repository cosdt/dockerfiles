# dockerfiles

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
