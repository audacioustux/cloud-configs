data "terraform_remote_state" "k8s-test" {
  backend = "remote"
  config = {
    organization = "nobinalo"
    workspaces = {
      name = "k8s-test"
    }
  }
}
