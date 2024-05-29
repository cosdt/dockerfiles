group "default" {
  targets = ["cann"]
}

target "cann" {
  context = "cann"
  dockerfile = "ubuntu/Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BASE_VERSION = "22.04"
  }
}
