module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name = var.project
  cidr = "10.0.0.0/16"

  azs                         = ["eu-central-1a"]
  public_subnets              = ["10.0.101.0/24"]
  public_subnet_ipv6_prefixes = [0]
  private_subnets             = []

  enable_ipv6                                   = true
  assign_ipv6_address_on_creation               = true
  public_subnet_assign_ipv6_address_on_creation = true

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {}
}
