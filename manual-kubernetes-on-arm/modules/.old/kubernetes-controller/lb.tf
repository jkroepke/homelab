resource "aws_lb" "this" {
  name               = "${var.project_name}-controller"
  internal           = false
  load_balancer_type = "network"
  subnets            = values(var.subnets)

  ip_address_type = "dualstack"
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
  name        = "${var.project_name}-controller"
  port        = 6443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = var.subnets

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this[each.key].id
  port             = aws_lb_target_group.this.port
}


resource "aws_route53_record" "this" {
  name    = "${var.project_name}-controller"
  type    = "AAAA"
  zone_id = var.route53_zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}
