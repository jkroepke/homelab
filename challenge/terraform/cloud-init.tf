data "template_cloudinit_config" "kickstart" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "kickstart.yaml"
    content_type = "text/cloud-config"
    content = file("../cloud-init/kickstart.yaml")
  }
}
