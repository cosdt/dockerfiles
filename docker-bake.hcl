variable "registries" {
  default = <<EOT
[
  {
    "registry": "docker.io",
    "owner": "ascend"
  },
  {
    "registry": "ghcr.io",
    "owner": "ascend"
  }
]
EOT
}

function "generate_tags" {
  params = [repo, tag]
  result = [
    for reg in jsondecode(registries) : lower("${reg.registry}/${reg.owner}/${repo}:${tag}")
  ]
}

group "default" {
  targets = ["cann-all", "cann-prefer"]
}

group "cann" {
  targets = ["cann-all", "cann-prefer"]
}

target "base-target" {
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.authors" = "Ascend Open Source <ascend@huawei.com>",
    "org.opencontainers.image.description" = "A Docker image built by Ascend"
  }
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
