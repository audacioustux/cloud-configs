variable "cloudflare_api_token" { type = string }
variable "craftkori_ip_addr" { type = string }
variable "k8s_test_ip_addr" {
  type    = string
  default = data.oci_core_public_ip.k3s_test_server-public_ip.ip_address
}
variable "k8s_prod_ip_addr" { type = string }
