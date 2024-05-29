group "default" {
  targets = ["cann"]
}

target "cann" {
  context = "cann"
  dockerfile = "ubuntu/Dockerfile"
}
