data "terraform_remote_state" "networking-test" {
  backend = "remote"
  config = {
    organization = "nobinalo"
    workspaces = {
      name = "networking-test"
    }
  }
}

data "oci_core_subnet" "public_subnet" {
  subnet_id = data.terraform_remote_state.networking-test.outputs.public_subnet.id
}

data "oci_core_vcn" "default" {
  vcn_id = data.oci_core_subnet.public_subnet.vcn_id
}
