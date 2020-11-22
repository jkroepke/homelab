data "aws_route53_zone" "adorsys-sandbox" {
  name = "${var.root_dns_zone}."
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

  ttl = "300"

  records = aws_route53_zone.dns.name_servers
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.dns.id

  name = var.kubernetes.api_hostname
  type = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "bastion_public" {
  for_each = {
    "A"    = [aws_eip.bastion.public_ip]
    "AAAA" = aws_instance.bastion.ipv6_addresses
  }

  zone_id = aws_route53_zone.dns.id

  name = "bastion.${aws_route53_zone.dns.name}"
  type = each.key

  ttl = "300"

  records = each.value
}


resource "aws_route53_record" "router_public" {
  zone_id = aws_route53_zone.dns.id

  name = "*.${aws_route53_zone.dns.name}"
  type = "CNAME"

  ttl = "300"

  records = [aws_route53_zone.dns.name]
}
