module "route53" {
  source = "./modules/route53/"

  name          = local.project
  root_dns_zone = "adorsys-sandbox.aws.adorsys.de"
}
