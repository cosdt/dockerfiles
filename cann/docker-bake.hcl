group "default" {
  targets = ["cann-ubuntu"]
}

target "cann-ubuntu" {
  context = "."
  dockerfile = "ubuntu/Dockerfile"
  matrix = {
    UBUNTU_VERSION = ["22.04", "24.04"]
  }
  args = {
    BASE_VERSION = ${UBUNTU_VERSION}
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["cann:ubuntu${BASE_VERSION}"]
}
