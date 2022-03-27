resource "aws_ebs_volume" "etcd" {
  for_each = local.etcd_peers

  availability_zone = keys(var.vpc_private_subnets)[each.key - 1]
  encrypted         = true

  size = 30
  type = "gp3"

  tags = {
    Name = "${var.cluster_name}-data-${each.value}"
    peer = each.value
  }
}
