resource "aws_route53_zone" "local" {
  name = "k8s.local"
  vpc {
    vpc_id = aws_vpc.vpc.id
  }

  tags = {
    project = var.name
  }
}
