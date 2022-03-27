module "security_groups" {
  source       = "./modules/security_groups"

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
}
