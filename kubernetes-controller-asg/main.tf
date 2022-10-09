locals {
  etcd_domain = "${var.project}.etcd.local"

  controllers = {
    for index in range(0, var.worker_count) : values(data.aws_subnet.this)[index].availability_zone => {
      name           = "${var.project}-controller-${values(data.aws_subnet.this)[index].availability_zone}"
      subnet_id      = keys(data.aws_subnet.this)[index]
      etcd_peer_name = "etcd-${values(data.aws_subnet.this)[index].availability_zone}.${local.etcd_domain}"
    }
  }
}

data "aws_vpc" "this" {
  default = true
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_subnet" "this" {
  for_each = toset(data.aws_subnets.this.ids)
  id       = each.value
}

module "controller_scale_handler" {
  source = "./modules/controller_scale_handler"

  name                  = "${var.project}-controller-scale-handler"
  route53_zone_id       = aws_route53_zone.this.id
  autoscale_group_names = [for properties in values(local.controllers) : properties.name]
}

module "controller" {
  for_each = local.controllers

  source = "./modules/controller"

  name                  = each.value.name
  vpc_id                = data.aws_vpc.this.id
  subnet_id             = each.value.subnet_id
  availability_zone     = each.key
  route53_zone_id       = aws_route53_zone.this.id
  lb_target_group_arn   = aws_lb_target_group.controller.arn
  user_data             = ""
  vpc_security_group_id = aws_security_group.this.id
  etcd_peer_name        = each.value.etcd_peer_name
}
