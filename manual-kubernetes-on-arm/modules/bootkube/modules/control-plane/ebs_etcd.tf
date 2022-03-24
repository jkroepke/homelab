resource "aws_ebs_volume" "etcd" {
  for_each = local.etcd_peers

  availability_zone = keys(var.vpc_subnets)[each.key]
  encrypted         = true

  size = 30
  type = "gp3"

  tags = {
    Name = "data-${each.value}"
  }
}
