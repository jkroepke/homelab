resource "aws_lb" "this" {
  name               = "${var.cluster_name}-api"
  internal           = false
  load_balancer_type = "network"
  subnets            = values(var.vpc_public_subnets)

  enable_cross_zone_load_balancing = false
  ip_address_type                  = "dualstack"
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = aws_lb_target_group.this.port
  protocol          = aws_lb_target_group.this.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name        = "${var.cluster_name}-api"
  port        = 6443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  preserve_client_ip = false
}

resource "aws_route53_record" "this" {
  for_each = toset(["A", "AAAA"])

  name    = var.kubernetes_api_hostname
  type    = each.key
  zone_id = var.route53_zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}
