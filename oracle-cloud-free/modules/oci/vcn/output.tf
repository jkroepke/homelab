output "vcn_id" {
  value = oci_core_vcn.this.id
}

output "public_subnet_ids" {
  value = [for subnet, properties in oci_core_subnet.public: properties.id]
}

output "private_subnet_ids" {
  value = [for subnet, properties in oci_core_subnet.private: properties.id]
}
