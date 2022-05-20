output "k3s-server-ip" {
  value = oci_core_instance.k3s_server.public_ip
}
