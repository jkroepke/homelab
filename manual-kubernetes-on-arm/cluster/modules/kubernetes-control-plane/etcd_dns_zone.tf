resource "aws_route53_zone" "etcd" {
  name = local.etcd_domain
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "etcd_discovery" {
  name = "_etcd-server-ssl._tcp"

  type    = "SRV"
  zone_id = aws_route53_zone.etcd.id
  ttl     = 600

  records = [for peer in local.etcd_peers : "0 0 2380 ${peer}"]
}

resource "aws_route53_record" "etcd_member_A" {
  for_each = local.controllers

  name = local.etcd_peers[each.key]

  type    = "A"
  zone_id = aws_route53_zone.etcd.id
  ttl     = 600

  records = [aws_instance.this[each.key].private_ip]
}
