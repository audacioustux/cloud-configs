variable "private_key" { type = string }
variable "private_key_password" { type = string }

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.73.0"
    }
  }
}

provider "oci" {
  private_key = var.private_key
  private_key_password = var.private_key_password
}