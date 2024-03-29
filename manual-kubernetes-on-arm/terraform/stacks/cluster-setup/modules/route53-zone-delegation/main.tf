data "aws_route53_zone" "parent" {
  name = "${var.root_dns_zone}."
}

resource "aws_route53_zone" "this" {
  name = "${var.name}.${data.aws_route53_zone.parent.name}"

  force_destroy = true
}

resource "aws_route53_record" "parent_NS" {
  zone_id = data.aws_route53_zone.parent.id

  name = aws_route53_zone.this.name
  type = "NS"

  ttl = 300

  records = aws_route53_zone.this.name_servers
}

resource "aws_route53_record" "parent_DS" {
  zone_id = data.aws_route53_zone.parent.id
  name    = aws_route53_zone.this.name
  type    = "DS"
  ttl     = 300
  records = [aws_route53_key_signing_key.this.ds_record]

  depends_on = [aws_route53_hosted_zone_dnssec.this]
}

