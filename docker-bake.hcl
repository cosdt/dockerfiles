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
  name = replace("cann-${cann_version}-${cann_chip}-${os.name}${os.version}", ".", "_")
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
    cann_chip = ["310p", "910b"]
    cann_version = ["7.0.1", "8.0.RC1"]
  }
  args = {
    BASE_VERSION = "${os.version}"
    CANN_CHIP = "${cann_chip}"
    CANN_VERSION = "${cann_version}"
  }
  tags = generate_tags("cann", "${cann_version}-${cann_chip}-${os.name}${os.version}")
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
        cann_chip = "910b"
        cann_version = "8.0.RC1"
      },
      {
        tag = "8.0"
        os = "ubuntu"
        os_version = "22.04"
        cann_chip = "910b"
        cann_version = "8.0.RC1"
      },
      {
        tag = "7.0"
        os = "ubuntu"
        os_version = "22.04"
        cann_chip = "910b"
        cann_version = "7.0.0"
      },
    ]
  }
  args = {
    BASE_VERSION = "${item.os_version}"
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
        tag = "2.1.0"
        cann_version = "8.0"
        pytorch_version = "2.1.0"
        torch_npu_version = "2.1.0.post3"
      },
      {
        tag = "2.2.0"
        cann_version = "8.0"
        pytorch_version = "2.2.0"
        torch_npu_version = "2.2.0"
      }
    ]
  }
  args = {
    BASE_NAME = "${registry.url}/${registry.owner}/cann"
    BASE_VERSION = "${item.cann_version}"
    PYTORCH_VERSION = "${item.pytorch_version}"
    TORCH_NPU_VERSION = "${item.torch_npu_version}"
  }
  tags = [
    "${registry.url}/${registry.owner}/pytorch:${item.tag}"
  ]
}
