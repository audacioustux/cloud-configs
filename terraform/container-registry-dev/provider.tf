variable "private_key" { type = string }
variable "compartment_ocid" { type = string }

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.73.0"
    }
  }
}

// NOTE: couldn't use TF_VAR_private_key in terraform cloud
provider "oci" {
  private_key          = var.private_key
}