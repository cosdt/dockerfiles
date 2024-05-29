group "default" {
  targets = ["cann-ubuntu"]
}

target "cann-ubuntu" {
  context = "."
  dockerfile = "ubuntu/Dockerfile"
  matrix = {
    BASE_VERSION = ["22.04", "24.04"]
  }
  args = {
    BASE_VERSION = ${BASE_VERSION}
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["cann:ubuntu${BASE_VERSION}"]
}
