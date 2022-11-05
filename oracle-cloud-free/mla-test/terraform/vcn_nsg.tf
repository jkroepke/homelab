resource "oci_core_network_security_group" "default" {
  compartment_id = var.tenancy_ocid
  vcn_id         = module.vpc.vcn_id
  display_name   = "oracle.jkroepke.de"
}

resource "oci_core_network_security_group_security_rule" "default_ingress_ssh" {
  #Required
  network_security_group_id = oci_core_network_security_group.default.id
  direction                 = "INGRESS"
  protocol                  = 6

  #Optional
  description = "SSH"
  source = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "default_ingress_alt_ssh" {
  #Required
  network_security_group_id = oci_core_network_security_group.default.id
  direction                 = "INGRESS"
  protocol                  = 6

  #Optional
  description = "SSH (ALT)"
  source = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 8022
      min = 8022
    }
  }
}

resource "oci_core_network_security_group_security_rule" "default_ingress_http" {
  #Required
  network_security_group_id = oci_core_network_security_group.default.id
  direction                 = "INGRESS"
  protocol                  = 6

  #Optional
  description = "HTTP"
  source = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "default_ingress_https" {
  #Required
  network_security_group_id = oci_core_network_security_group.default.id
  direction                 = "INGRESS"
  protocol                  = 6

  #Optional
  description = "HTTPS"
  source = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "default_egress_all" {
  #Required
  network_security_group_id = oci_core_network_security_group.default.id
  direction                 = "EGRESS"
  protocol                  = "all"

  #Optional
  description      = "Internet"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
}

