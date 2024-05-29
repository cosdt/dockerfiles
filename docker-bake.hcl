group "default" {
  targets = ["cann"]
}

target "cann" {
  context = "cann"
  dockerfile = "ubuntu/Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  matrix = {
    UBUNTU_VERSION = ["22.04", "24.04"]
    PY_VERSION = ["3.8.0", "3.9.0", "3.10.0"]
    CANN_VERSION = ["8.0.RC1"]
  }
  args = {
    BASE_VERSION = "${UBUNTU_VERSION}"
    PY_VERSION = "${PY_VERSION}"
    CANN_VERSION = "${CANN_VERSION}"
  }
  tags = ["cann:${CANN_VERSION}-ubuntu${UBUNTU_VERSION}-py${PY_VERSION}"]
}
