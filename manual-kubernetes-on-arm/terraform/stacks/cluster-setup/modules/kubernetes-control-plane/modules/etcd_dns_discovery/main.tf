resource "aws_route53_zone" "this" {
  name = var.etcd_domain

  force_destroy = true

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "this" {
  name = "_etcd-server-ssl._tcp.${var.etcd_domain}"

  type    = "SRV"
  zone_id = aws_route53_zone.this.id
  ttl     = 86400

  records = [for peer in var.etcd_peer_names : "0 0 2380 ${peer}"]
}
