variable "ssh_public_key" { type = string }

resource "random_password" "cluster_token" {
  length = 64
}

resource "oci_core_instance" "k3s_server" {
  availability_domain = data.oci_identity_availability_domains.default.availability_domains.0.name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.A1.Flex"

  display_name = "k3s server"

  create_vnic_details {
    subnet_id        = data.oci_core_subnet.public_subnet.id
    display_name     = "primary"
    assign_public_ip = true
    hostname_label   = "k3s-server"
  }

  source_details {
    source_id               = data.oci_core_images.aarch64.images.0.id
    source_type             = "image"
    boot_volume_size_in_gbs = 100
  }

  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.template_cloudinit_config.k3s_server.rendered
  }

  lifecycle {
    ignore_changes = [
      source_details
    ]
  }
}
