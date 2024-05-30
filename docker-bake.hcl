variable "registry" {
  default = "docker.io"
}

variable "owner" {
  default = "ascend"
}

group "default" {
  targets = ["cann-ubuntu", "cann-openeuler"]
}

target "base" {
  labels = {
    "org.opencontainers.image.source" = "https://github.com/cosdt/dockerfiles"
  }
}

target "release" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "cann-base" {
  inherits = ["base"]
  name = "cann"
  context = "cann"
  dockerfile = "Dockerfile"
  matrix = {
    py_version = ["3.10.0"]
    cann_version = ["8.0.RC1"]
  }
  args = {
    PY_VERSION = "${py_version}"
    CANN_VERSION = "${cann_version}"
  }
}

target "cann-ubuntu" {
  name = replace("cann-${cann_version}-ubuntu${base_version}-py${py_version}", ".", "_")
  context = "cann"
  dockerfile = "ubuntu/Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  matrix = {
    base_version = ["22.04"]
    py_version = ["3.10.0"]
    cann_version = ["8.0.RC1"]
  }
  args = {
    BASE_VERSION = "${base_version}"
    PY_VERSION = "${py_version}"
    CANN_VERSION = "${cann_version}"
  }
  tags = ["${registry}/${owner}/cann:${cann_version}-ubuntu${base_version}-py${py_version}"]
}

target "cann-openeuler" {
  name = replace("cann-${cann_version}-openeuler${base_version}-py${py_version}", ".", "_")
  context = "cann"
  dockerfile = "openeuler/Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  matrix = {
    base_version = ["22.03"]
    py_version = ["3.10.0"]
    cann_version = ["8.0.RC1"]
  }
  args = {
    BASE_VERSION = "${base_version}"
    PY_VERSION = "${py_version}"
    CANN_VERSION = "${cann_version}"
  }
  tags = ["${registry}/${owner}/cann:${cann_version}-openeuler${base_version}-py${py_version}"]
}
