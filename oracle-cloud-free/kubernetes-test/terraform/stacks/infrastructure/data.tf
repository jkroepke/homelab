data "oci_identity_availability_domains" "available" {
  #Required
  compartment_id = var.tenancy_ocid
}
