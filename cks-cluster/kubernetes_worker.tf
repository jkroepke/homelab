module "worker" {
  source = "./modules/vm"
  count  = var.worker_count

  name        = "${var.project}-worker-${count.index}"
  ami_id      = data.aws_ami.ubuntu.id
  ip6_address = cidrhost(aws_subnet.this[local.availability_zone].ipv6_cidr_block, 11 + count.index)
  key_name    = data.aws_key_pair.jkr.key_name
  subnet_id   = aws_subnet.this[local.availability_zone].id
  vpc_id      = aws_vpc.this.id
}

resource "aws_security_group_rule" "worker-from-master" {
  count  = var.worker_count

  from_port         = 0
  protocol          = "-1"
  security_group_id = module.worker[count.index].security_group_id
  to_port           = 0
  type              = "ingress"

  source_security_group_id = module.master.security_group_id
}
