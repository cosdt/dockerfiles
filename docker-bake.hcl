group "default" {
  targets = ["cann"]
}

target "cann" {
  context = "cann"
  dockerfile = "ubuntu/Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  matrix = {
    ubuntu_version = ["22.04", "24.04"]
    py_version = ["3.8.0", "3.9.0", "3.10.0"]
    cann_version = ["8.0.RC1"]
  }
  tags = ["cann:${cann_version}-ubuntu${ubuntu_version}-py${py_version}"]
}
