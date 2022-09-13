data "terraform_remote_state" "networking-test" {
  backend = "remote"
  config = {
    organization = "nobinalo"
    workspaces = {
      name = "k8s-test"
    }
  }
}

data "oci_core_public_ip" "k3s_test_server-public_ip" {
  ip_address = data.terraform_remote_state.k8s-test.outputs.k3s-server-ip
}
