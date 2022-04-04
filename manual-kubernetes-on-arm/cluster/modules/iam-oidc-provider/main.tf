data "tls_certificate" "this" {
  url          = var.kubernetes_api_server
  verify_chain = false
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = var.kubernetes_api_server

  tags = {
    Name = "${var.cluster_name}-kubernetes"
  }
}
