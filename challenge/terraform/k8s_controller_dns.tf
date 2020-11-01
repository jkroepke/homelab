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
