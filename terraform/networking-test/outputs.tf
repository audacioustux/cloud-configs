output "private_subnet" {
  value = oci_core_subnet.private_subnet
}

output "public_subnet" {
  value = oci_core_subnet.public_subnet
}
