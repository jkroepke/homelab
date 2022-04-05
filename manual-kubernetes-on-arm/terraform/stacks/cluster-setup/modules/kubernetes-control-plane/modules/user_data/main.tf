locals {
  files_rendered = {
    for filename in fileset("${path.module}/resources/files/", "**/*") : "/${filename}" => {
      mode  = 644
      user  = "root"
      group = "root"

      content = templatefile("${path.module}/resources/files/${filename}", {})
    }
  }

  snippets = [for filename in fileset("${path.module}/resources/snippets/", "*.yaml") : templatefile("${path.module}/resources/snippets/${filename}", {
    kubernetes_version = var.kubernetes_version
  })]
}

module "ignition" {
  source = "../../../../../../modules/ignition"

  name     = var.name
  files    = merge(local.files_rendered, var.files)
  snippets = local.snippets
}
