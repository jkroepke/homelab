module "zone-delegation" {
  source = "./modules/route53-zone-delegation"

  name          = var.name
  root_dns_zone = "adorsys-sandbox.aws.adorsys.de"
}
