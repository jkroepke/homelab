data "aws_route53_zone" "adorsys-sandbox" {
  name = "adorsys-sandbox.aws.adorsys.de."
}

resource "aws_route53_zone" "dns" {
  name = "${var.name}.${data.aws_route53_zone.adorsys-sandbox.name}"
  tags = {
    project = var.name
  }
}

resource "aws_route53_record" "adorsys-sandbox_aws_adorsys_de_NS" {
  zone_id = data.aws_route53_zone.adorsys-sandbox.id
  name    = aws_route53_zone.dns.name
  type    = "NS"

  ttl = "3600"

  records = aws_route53_zone.dns.name_servers
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.dns.id

  name    = var.kubernetes.public_hostname
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "bastion_public_A" {
  zone_id = aws_route53_zone.dns.id

  name    = "bastion"
  type    = "A"

  ttl     = "3600"

  records = [aws_eip.bastion.public_ip]
}

resource "aws_route53_record" "bastion_public_AAAA" {
  zone_id = aws_route53_zone.dns.id

  name    = "bastion"
  type    = "AAAA"

  ttl     = "3600"

  records = aws_instance.bastion.ipv6_addresses
}
