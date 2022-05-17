data "terraform_remote_state" "networking-test" {
  backend = "remote"
  config = {
    organization = "nobinalo"
    workspaces = {
      name = "networking-test"
    }
  }
}
