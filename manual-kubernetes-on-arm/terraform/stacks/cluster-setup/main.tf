module "aws-system-manager" {
  source = "./modules/aws-system-manager"

  name = var.project_name
}

module "zone-delegation" {
  source = "./modules/route53-zone-delegation"

  name          = var.project_name
  root_dns_zone = var.parent_dns_zone

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}

module "security-groups" {
  source = "./modules/kubernetes-security-groups"

  name_prefix = local.cluster_name
  vpc_id      = module.vpc.id
}

module "kubernetes_ingress_acm" {
  source = "../../modules/acm"

  domain_name               = local.kubernetes_apps_domain
  subject_alternative_names = ["*.${local.kubernetes_apps_domain}"]
  zone_id                   = module.zone-delegation.zone_id
}

module "kubernetes-control-plane" {
  source = "./modules/kubernetes-control-plane"

  cluster_name = local.cluster_name

  vpc_id                 = module.vpc.id
  vpc_private_subnets    = module.vpc.private_subnets
  vpc_public_subnets     = module.vpc.public_subnets
  vpc_cidr_ipv4          = module.vpc.cidr_block
  vpc_cidr_ipv6          = module.vpc.ipv6_cidr_block
  route53_zone_id        = module.zone-delegation.zone_id
  vpc_security_group_ids = [module.security-groups.controller_security_group_id]
  key_name               = var.key_name

  controller_count        = var.kubernetes_controller_count
  instance_type           = var.kubernetes_controller_instance_type
  kubernetes_api_hostname = local.kubernetes_api_hostname
  kubernetes_oidc_issuer  = local.kubernetes_oidc_issuer

  etcd_version       = var.etcd_version
  kubernetes_version = var.kubernetes_version

  kubernetes_service_cidr = local.service_cidr
  kubernetes_pod_cidr     = local.pod_cidr
  cluster_dns             = local.cluster_dns

  iam_role_policy_attachments = module.aws-system-manager.iam_role_policy_arns
}

resource "local_file" "admin_kubeconfig" {
  filename        = pathexpand("~/.kube/admin_${local.cluster_name}")
  content         = module.kubernetes-control-plane.kubernetes_admin_config
  file_permission = "0600"
}
