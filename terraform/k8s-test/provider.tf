variable "oci_private_key" { type = string }
variable "oci_private_key_password" { type = string }
variable "compartment_ocid" { type = string }

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.73.0"
    }
  }
}

provider "oci" {
  private_key          = var.oci_private_key
  private_key_password = var.oci_private_key_password
}
