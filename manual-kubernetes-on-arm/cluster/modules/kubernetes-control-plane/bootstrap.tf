module "kubernetes-bootstrap" {
  source = "./modules/kubernetes/bootstrap"

  bootstrap_token_id     = module.pki_kubernetes.bootstrap_token_id
  bootstrap_token_secret = module.pki_kubernetes.bootstrap_token_secret

  depends_on = [data.http.wait_for_cluster]
}

data "http" "wait_for_cluster" {
  url            = "https://${var.kubernetes_api_hostname}:6443/healthz"
  ca_certificate = module.pki_kubernetes.ca_crt
  timeout        = 60

  depends_on = [
    aws_instance.this,
    aws_lb_listener.this,
    aws_lb_target_group_attachment.this,
    aws_route53_record.etcd_discovery,
    aws_route53_record.etcd_member_A
  ]
}
