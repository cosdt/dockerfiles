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
  name = replace("cann-${cann_version}-${os.name}${os.version}-py${py_version}", ".", "_")
  context = "cann"
  dockerfile = "${os.name}/Dockerfile"
  matrix = {
    os = [
      {
        name = "ubuntu"
        version = "22.04"
      }
    ]
    py_version = ["3.8", "3.9", "3.10"]
    cann_version = ["8.0.RC1"]
  }
  args = {
    BASE_VERSION = "${os.version}"
    PY_VERSION = "${py_version}"
    CANN_VERSION = "${cann_version}"
  }
  tags = ["${registry}/${owner}/cann:${cann_version}-${os.name}${os.version}-py${py_version}"]
}
