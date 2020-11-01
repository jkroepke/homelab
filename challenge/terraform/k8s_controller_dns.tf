resource "aws_route53_record" "controller_A" {
  for_each = local.controller_nodes

  zone_id = aws_route53_zone.local.zone_id
  name    = each.key
  type    = "A"
  ttl     = "60"

  records = [aws_instance.controller[each.key].private_ip]
}

resource "aws_route53_record" "controller_AAAA" {
  for_each = local.controller_nodes

  zone_id = aws_route53_zone.local.zone_id
  name    = each.key
  type    = "AAAA"
  ttl     = "60"

  records = aws_instance.controller[each.key].ipv6_addresses
}

resource "aws_route53_record" "etcd-server_SRV" {
  zone_id = aws_route53_zone.local.zone_id

  name    = "_etcd-server-ssl._tcp.etcd"
  ttl     = "300"
  type    = "SRV"

  records = [for name, instance in aws_instance.controller: "0 0 2380 ${instance.private_dns}."]
}


resource "aws_route53_record" "etcd-client_SRV" {
  zone_id = aws_route53_zone.local.zone_id

  name    = "_etcd-client-ssl._tcp.etcd"
  ttl     = "300"
  type    = "SRV"

  records = [for name, instance in aws_instance.controller: "0 0 2379 ${instance.private_dns}."]
}
