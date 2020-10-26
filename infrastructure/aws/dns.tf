resource "aws_route53_zone" "dns" {
  name = "k8s-hard-way.jkroepke.de"
  tags = {
    project = var.name
  }
}

resource "aws_route53_record" "a" {
  zone_id = aws_route53_zone.dns.id

  name    = "api.${aws_route53_zone.dns.name}"
  type    = "A"

  alias {
    name                   = aws_lb.api.dns_name
    zone_id                = aws_lb.api.zone_id
    evaluate_target_health = true
  }
}
