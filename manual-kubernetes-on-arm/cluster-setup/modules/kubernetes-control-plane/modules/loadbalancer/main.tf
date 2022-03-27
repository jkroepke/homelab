resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "network"
  subnets            = values(var.subnets)

  enable_cross_zone_load_balancing = false
  ip_address_type                  = "dualstack"
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.port
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  preserve_client_ip = false
}

resource "aws_route53_record" "this" {
  # Test w/o IPv4
  for_each = toset(["AAAA"])

  name    = var.hostname
  type    = each.key
  zone_id = var.route53_zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}
