data "oci_core_subnet" "private_subnet" {
  subnet_id = oci_core_subnet.private_subnet.id
}

data "oci_core_subnet" "public_subnet" {
  subnet_id = oci_core_subnet.public_subnet.id
}
