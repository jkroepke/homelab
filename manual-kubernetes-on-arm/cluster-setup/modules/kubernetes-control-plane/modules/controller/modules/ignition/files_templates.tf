locals {
  files_templates_list = fileset("${path.module}/resources/templates/", "**/*")

  files_templates_rendered = { for filename in local.files_templates_list : "/${filename}" => templatefile("${path.module}/resources/templates/${filename}", {
    region                    = data.aws_region.current.name
    kms_secret_encryption_arn = var.kms_secret_encryption_arn
    controller_count          = var.controller_count

    etcd_discovery_domain = var.etcd_discovery_domain
    etcd_peer_name        = var.etcd_peer_name
    etcd_version          = var.etcd_version

    kubernetes_version = var.kubernetes_version
    api_hostname       = var.kubernetes_api_hostname
    oidc_issuer_url    = var.kubernetes_oidc_issuer_url
    service_cidr       = var.service_cidr
    pod_cidr           = var.pod_cidr

    cluster_name = var.cluster_name
    cluster_dns  = var.cluster_dns
  }) }

  files_templates = [for filename in local.files_templates_list : templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
    path   = "/${filename}"
    bucket = aws_s3_bucket.this.bucket
    mode   = "0644"
    user   = "root"
    group  = "root"
  })]
}

resource "aws_s3_object" "templates" {
  for_each = local.files_templates_rendered

  bucket  = aws_s3_bucket.this.bucket
  key     = each.key
  content = each.value

  server_side_encryption = "AES256"

  etag        = md5(each.value)
  source_hash = md5(each.value)
}
