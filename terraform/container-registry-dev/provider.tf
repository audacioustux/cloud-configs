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
