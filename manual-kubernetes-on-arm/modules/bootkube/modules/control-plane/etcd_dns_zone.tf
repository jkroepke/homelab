resource "aws_route53_zone" "etcd" {
  name = local.etcd_domain
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "aaaa_controller" {
  for_each = local.controllers

  name = local.etcd_peers[each.key]

  type    = "AAAA"
  zone_id = aws_route53_zone.etcd.id
  ttl     = 600

  records = aws_instance.this[each.key].ipv6_addresses
}
