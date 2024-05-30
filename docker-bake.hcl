variable "registry" {
  default = "docker.io"
}

variable "owner" {
  default = "ascend"
}

group "default" {
  targets = ["cann"]
}

target "cann-base" {
  context = "cann"
}

target "base" {
  labels = {
    "org.opencontainers.image.source" = "https://github.com/cosdt/dockerfiles"
  }
}

target "release" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "cann" {
  name = replace("cann-${cann_version}-ubuntu${ubuntu_version}-py${py_version}", ".", "_")
  context = "cann"
  dockerfile = "ubuntu/Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  matrix = {
    ubuntu_version = ["22.04", "24.04"]
    py_version = ["3.10.0"]
    cann_version = ["8.0.RC1"]
  }
  args = {
    BASE_VERSION = "${ubuntu_version}"
    PY_VERSION = "${py_version}"
    CANN_VERSION = "${cann_version}"
  }
  tags = ["${registry}/${owner}/cann:${cann_version}-ubuntu${ubuntu_version}-py${py_version}"]
}
