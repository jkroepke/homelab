resource "aws_route53_zone" "this" {
  name = local.etcd_domain

  force_destroy = true

  vpc {
    vpc_id = data.aws_vpc.this.id
  }
}
