resource "aws_route53_record" "bastion_A" {
  zone_id = aws_route53_zone.local.zone_id
  name    = aws_instance.bastion.tags.Name
  type    = "A"
  ttl     = "60"

  records = [aws_instance.bastion.private_ip]
}

resource "aws_route53_record" "bastion_AAAA" {
  zone_id = aws_route53_zone.local.zone_id
  name    = aws_instance.bastion.tags.Name
  type    = "AAAA"
  ttl     = "60"

  records = aws_instance.bastion.ipv6_addresses
}
