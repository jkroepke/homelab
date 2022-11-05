resource "oci_core_instance" "test_instance" {
  #Required
  availability_domain = "qKnI:EU-FRANKFURT-1-AD-2"
  compartment_id = var.tenancy_ocid
  shape = "VM.Standard.A1.Flex"

  #Optional
  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled = false
    is_monitoring_disabled = true
  }

  availability_config {
    recovery_action             = "RESTORE_INSTANCE"
    is_live_migration_preferred = true
  }

  create_vnic_details {
    assign_private_dns_record = false
    assign_public_ip          = true
    display_name              = "oracle.jkroepke.de"
    subnet_id                 = module.vpc.public_subnet_ids[0]
    nsg_ids                   = [oci_core_network_security_group.default.id]
  }

  display_name = "oracle.jkroepke.de"

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  is_pv_encryption_in_transit_enabled = true

  metadata = { "ssh_authorized_keys" : "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKDxGg1XxTVeplkhVWaZUkXqXPR8MILX9XlVvyqMZdp"}

  shape_config {
    baseline_ocpu_utilization = "BASELINE_1_1"
    memory_in_gbs             = 24
    ocpus                     = 4
  }

  source_details {
    #Required
    source_id = data.oci_core_images.ubuntu-22-04-minimal.images[0].id
    source_type = "image"

    boot_volume_size_in_gbs = 200
  }

  preserve_boot_volume = true
}

data "oci_core_images" "ubuntu-22-04-minimal" {
  compartment_id   = var.tenancy_ocid
  operating_system = "Canonical Ubuntu"
  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-22.04-Minimal-aarch64-([\\.0-9-]+)$"]
    regex  = true
  }

  shape = "VM.Standard.A1.Flex"

  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}
