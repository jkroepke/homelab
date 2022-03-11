resource "aws_route53_zone" "private" {
  name = "jkr.local"

  vpc {
    vpc_id = module.vpc.id
  }
}
