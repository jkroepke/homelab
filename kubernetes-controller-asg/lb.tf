resource "aws_lb" "api" {
  name               = "${var.project}-api"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnets.this.ids
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
  name     = "${var.project}-api"
  port     = 6443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.this.id

  target_type = "instance"
}
