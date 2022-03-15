module "ssm" {
  source = "./modules/ssm/"

  project = local.project
}
