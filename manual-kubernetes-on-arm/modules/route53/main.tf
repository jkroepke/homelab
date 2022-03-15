data "aws_route53_zone" "adorsys-sandbox" {
  name = "${var.root_dns_zone}."
}

resource "aws_route53_zone" "this" {
  name = "${var.name}.${data.aws_route53_zone.adorsys-sandbox.name}"
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.adorsys-sandbox.id
  name    = aws_route53_zone.this.name
  type    = "NS"

  ttl = "600"

  records = aws_route53_zone.this.name_servers
}
