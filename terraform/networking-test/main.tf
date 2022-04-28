variable "vcn_subnet" { default = "10.0.0.0/16" }
variable "public_subnet" { default = "10.0.0.0/24" }
variable "compartment_ocid" { type = string }

resource "oci_core_vcn" "default" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_subnet
  dns_label      = "default"
  display_name   = "default"
}


resource "oci_core_internet_gateway" "default" {
  compartment_id = var.compartment_ocid
  display_name   = "default"
  vcn_id         = oci_core_vcn.default.id
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block     = var.public_subnet
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "public_subnet"
  dns_label      = "default"
}

resource "oci_core_default_route_table" "default" {
  manage_default_resource_id = oci_core_vcn.default.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.default.id

    description = "internet gateway"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_default_security_list" "default" {
  manage_default_resource_id = oci_core_vcn.default.default_security_list_id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}