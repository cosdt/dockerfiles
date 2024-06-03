variable "registry" {
  default = "docker.io"
}

variable "owner" {
  default = "ascend"
}

group "default" {
  targets = ["cann"]
}

target "base-target" {
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.authors" = "Ascend Open Source <ascend@huawei.com>"
    "org.opencontainers.image.description" = "A Docker image built by Ascend"
  }
}

target "cann" {
  inherits = ["base-target"]
  name = replace("cann-${cann_version}-${cann_chip}-${os.name}${os.version}-py${py_version}", ".", "_")
  context = "cann"
  dockerfile = "${os.name}/Dockerfile"
  matrix = {
    os = [
      {
        name = "ubuntu"
        version = "22.04"
      }
    ]
    py_version = ["3.10"]
    cann_chip = ["310p", "910b"]
    cann_version = ["7.0.0", "8.0.RC1"]
  }
  args = {
    BASE_VERSION = "${os.version}"
    PY_VERSION = "${py_version}"
    CANN_CHIP = "${cann_chip}"
    CANN_VERSION = "${cann_version}"
  }
  tags = [
    lower("${registry}/${owner}/cann:${cann_version}-${cann_chip}-${os.name}${os.version}-py${py_version}")
  ]
}
