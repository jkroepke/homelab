output "rendered" {
  value = data.template_cloudinit_config.this.rendered
}

output "base64_encode" {
  value = data.template_cloudinit_config.this.base64_encode
}
