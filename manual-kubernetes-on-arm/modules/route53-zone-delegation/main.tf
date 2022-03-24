data "aws_route53_zone" "parent" {
  name = "${var.root_dns_zone}."
}

resource "aws_route53_zone" "this" {
  name = "${var.name}.${data.aws_route53_zone.parent.name}"
}

resource "aws_route53_record" "parent" {
  zone_id = data.aws_route53_zone.parent.id

  name    = aws_route53_zone.this.name
  type    = "NS"

  ttl = "600"

  records = aws_route53_zone.this.name_servers
}
