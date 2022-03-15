module "vpc" {
  source = "./modules/vpc/"

  name     = local.project
  vpc_cidr = local.vpc_cidr
}
