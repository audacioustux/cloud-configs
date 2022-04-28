terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.73.0"
    }
  }
}

provider "oci" {
    fingerprint             = var.fingerprint
    user_ocid               = var.user_ocid
    tenancy_ocid            = var.tenancy_ocid
    compartment_ocid        = var.compartment_ocid
    private_key             = var.private_key
    private_key_password    = var.private_key_password
}