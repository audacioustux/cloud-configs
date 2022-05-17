variable "vcn_subnet" { default = "10.0.0.0/16" }
variable "private_subnet" { default = "10.0.2.0/23" }
variable "public_subnet" { default = "10.0.0.0/23" }

resource "oci_core_vcn" "default" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_subnet
  display_name   = "default vcn"
  dns_label      = "default"
}

resource "oci_core_internet_gateway" "default" {
  compartment_id = var.compartment_ocid
  display_name   = "default gateway"
  vcn_id         = oci_core_vcn.default.id
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block     = var.public_subnet
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "public subnet"
  dns_label      = "public"
}

resource "oci_core_subnet" "private_subnet" {
  cidr_block     = var.private_subnet
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "private subnet"
  dns_label      = "private"
  route_table_id = oci_core_route_table.private.id
}

resource "oci_core_default_route_table" "default" {
  manage_default_resource_id = oci_core_vcn.default.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.default.id

    description = "internet gateway"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  display_name = "private route table"
}


resource "oci_core_default_security_list" "default" {
  manage_default_resource_id = oci_core_vcn.default.default_security_list_id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "SSH"

    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Kubernetes API"

    tcp_options {
      max = 6443
      min = 6443
    }
  }
}
