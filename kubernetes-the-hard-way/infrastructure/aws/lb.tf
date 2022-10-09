resource "aws_lb" "api" {
  name               = "${var.name}-api"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.subnet : subnet.id]

  enable_cross_zone_load_balancing = false

  tags = {
    project = var.name
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = aws_lb_target_group.controller.port
  protocol          = aws_lb_target_group.controller.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controller.arn
  }
}

resource "aws_lb_target_group" "controller" {
  name     = "${var.name}-api"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  target_type = "instance"
  health_check {
    enabled = true

    path     = "/healthz"
    protocol = "HTTPS"
  }
}

resource "aws_lb_target_group_attachment" "controller" {
  for_each = aws_instance.controller

  target_group_arn = aws_lb_target_group.controller.arn
  target_id        = each.value.id
  port             = aws_lb_listener.api.port
}
