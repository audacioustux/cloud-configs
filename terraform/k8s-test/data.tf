data "oci_identity_availability_domains" "default" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "aarch64" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"

  filter {
    name   = "display_name"
    values = ["^.*-aarch64-.*$"]
    regex  = true
  }
}

data "oci_core_images" "amd64" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"

  filter {
    name   = "display_name"
    values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}

data "template_cloudinit_config" "k3s_server" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "k3s_server.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.k3s_server_cloud_init_file.rendered
  }
}

data "template_file" "k3s_server_template" {
  template = file("scripts/k3s_server.template.sh")

  vars = {
    cluster_token               = random_password.cluster_token.result
    container_registry_host     = var.container_registry_host
    container_registry_username = var.container_registry_username
    container_registry_password = var.container_registry_password
  }
}

data "template_file" "k3s_server_cloud_init_file" {
  template = file("cloud-init/cloud-init.template.yaml")

  vars = {
    bootstrap_sh_content = base64gzip(data.template_file.k3s_server_template.rendered)
  }
}

