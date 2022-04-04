resource "aws_route53_zone" "this" {
  name = local.etcd_domain

  vpc {
    vpc_id = data.aws_vpc.this.id
  }
}
