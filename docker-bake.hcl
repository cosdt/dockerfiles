variable "registries" {
  default = <<EOT
[
  {
    "url": "docker.io",
    "owner": "ascend"
  },
  {
    "url": "ghcr.io",
    "owner": "ascend"
  }
]
EOT
}

function "generate_tags" {
  params = [repo, tag]
  result = [
    for reg in jsondecode(registries) : lower("${reg.url}/${reg.owner}/${repo}:${tag}")
  ]
}

group "default" {
  targets = ["cann-all", "cann-prefer", "pytorch-all"]
}

group "cann" {
  targets = ["cann-all", "cann-prefer"]
}

group "pytorch" {
  targets = ["pytorch-all"]
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
}

target "base-target" {
  inherits = ["docker-metadata-action"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "cann-all" {
  inherits = ["base-target"]
  name = replace("cann-${cann_version}-${cann_chip}-${os.name}${os.version}-py${py_version}", ".", "_")
  context = "cann"
  dockerfile = "${os.name}/Dockerfile"
  matrix = {
    os = [
      {
        name = "ubuntu"
        version = "20.04"
      },
      {
        name = "ubuntu"
        version = "22.04"
      },
      {
        name = "openeuler"
        version = "20.03"
      },
      {
        name = "openeuler"
        version = "22.03"
      }
    ]
    py_version = ["3.8"]
    cann_chip = ["310p", "910", "910b"]
    cann_version = ["7.0.1", "8.0.RC1", "8.0.RC2.alpha002"]
  }
  args = {
    BASE_VERSION = "${os.version}"
    PY_VERSION = "${py_version}"
    CANN_CHIP = "${cann_chip}"
    CANN_VERSION = "${cann_version}"
  }
  tags = generate_tags("cann", "${cann_version}-${cann_chip}-${os.name}${os.version}-py${py_version}")
}

target "cann-prefer" {
  inherits = ["base-target"]
  name = replace("cann-${item.tag}", ".", "_")
  context = "cann"
  dockerfile = "${item.os}/Dockerfile"
  matrix = {
    item = [
      {
        tag = "latest"
        os = "ubuntu"
        os_version = "22.04"
        py_version = "3.10"
        cann_chip = "910b"
        cann_version = "8.0.RC2.alpha002"
      },
      {
        tag = "8.0"
        os = "ubuntu"
        os_version = "22.04"
        py_version = "3.10"
        cann_chip = "910b"
        cann_version = "8.0.RC2.alpha002"
      },
      {
        tag = "7.0"
        os = "ubuntu"
        os_version = "22.04"
        py_version = "3.10"
        cann_chip = "910b"
        cann_version = "7.0.1"
      },
    ]
  }
  args = {
    BASE_VERSION = "${item.os_version}"
    PY_VERSION = "${item.py_version}"
    CANN_CHIP = "${item.cann_chip}"
    CANN_VERSION = "${item.cann_version}"
  }
  tags = generate_tags("cann", "${item.tag}")
}

target "pytorch-all" {
  inherits = ["base-target"]
  name = replace("${registry.url}-pytorch-${item.tag}", ".", "_")
  context = "pytorch"
  dockerfile = "new.Dockerfile"
  matrix = {
    registry = jsondecode(registries)
    item = [
      {
        cann_tag = "8.0"
        pytorch_version = "2.1.0"
      },
      {
        cann_tag = "8.0"
        pytorch_version = "2.2.0"
      }
    ]
  }
  args = {
    BASE_NAME = "${registry.url}/${registry.owner}/cann"
    BASE_VERSION = "${item.cann_tag}"
    PYTORCH_VERSION = "${item.pytorch_version}"
  }
  tags = [
    "${registry.url}/${registry.owner}/pytorch:${item.pytorch_version}"
  ]
}
