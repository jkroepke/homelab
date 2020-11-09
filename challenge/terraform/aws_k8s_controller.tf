locals {
  controller_nodes = {for k, v in {
    1: {},
    2: {},
    3: {},
  }: "controller${k}" => {
    availability_zone = var.availability_zones[(k - 1) % length(var.availability_zones)],
    subnet_id         = aws_subnet.subnet[
      var.availability_zones[(k - 1) % length(var.availability_zones)]
    ].id,
  }}
}
