group "default" {
  targets = ["cann"]
}

target "cann" {
  context = "cann"
  dockerfile = "ubuntu/Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  matrix = {
    ubuntu_version = ["22.04", "24.04"]
  }
  args = {
    BASE_VERSION = ubuntu_version
  }
}
