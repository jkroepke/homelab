resource "aws_lb" "lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.subnet: subnet.id]

  enable_cross_zone_load_balancing = false

  tags = {
    project = var.name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = aws_lb_target_group.http.port
  protocol          = aws_lb_target_group.http.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_target_group" "http" {
  name     = "${var.name}-ingress-http"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  target_type = "instance"
  proxy_protocol_v2 = true

  health_check {
    enabled = true

    path     = "/healthz"
    protocol = "HTTPS"
    port     = "6443"
  }
}

resource "aws_lb_target_group_attachment" "http" {
  for_each = aws_instance.controller

  target_group_arn = aws_lb_target_group.http.arn
  target_id        = each.value.id
  port             = 32080
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = aws_lb_target_group.https.port
  protocol          = aws_lb_target_group.https.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https.arn
  }
}

resource "aws_lb_target_group" "https" {
  name     = "${var.name}-ingress-https"
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  target_type = "instance"
  proxy_protocol_v2 = true

  health_check {
    enabled = true

    path     = "/healthz"
    protocol = "HTTPS"
    port     = "6443"
  }
}

resource "aws_lb_target_group_attachment" "https" {
  for_each = aws_instance.controller

  target_group_arn = aws_lb_target_group.https.arn
  target_id        = each.value.id
  port             = 32443
}

resource "aws_lb_listener" "k8s-api" {
  load_balancer_arn = aws_lb.lb.arn
  port              = aws_lb_target_group.k8s-api.port
  protocol          = aws_lb_target_group.k8s-api.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s-api.arn
  }
}

resource "aws_lb_target_group" "k8s-api" {
  name     = "${var.name}-k8s-api"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  target_type = "instance"

  health_check {
    enabled = true

    path     = "/healthz"
    protocol = "HTTPS"
    port     = "6443"
  }
}

resource "aws_lb_target_group_attachment" "k8s-api" {
  for_each = aws_instance.controller

  target_group_arn = aws_lb_target_group.k8s-api.arn
  target_id        = each.value.id
  port             = aws_lb_listener.k8s-api.port
}
