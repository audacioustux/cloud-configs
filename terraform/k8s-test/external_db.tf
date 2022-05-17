resource "random_password" "sqlpassword" {
  length = 24
}

resource "oci_core_instance" "external_db" {
  availability_domain = data.oci_identity_availability_domains.default.availability_domains.0.name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.E2.1.Micro"

  display_name = "external db"

  create_vnic_details {
    subnet_id        = data.terraform_remote_state.networking-test.outputs.oci_core_subnet.private_subnet.id
    display_name     = "primary"
    assign_public_ip = false
    hostname_label   = "external-db"
  }

  source_details {
    source_id   = data.oci_core_images.amd64.images.0.id
    source_type = "image"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.template_cloudinit_config.external_db.rendered
  }

  lifecycle {
    ignore_changes = [
      source_details
    ]
  }
}
