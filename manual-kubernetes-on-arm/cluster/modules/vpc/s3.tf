data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  route_table_ids = [
    aws_route_table.public.id,
    aws_route_table.private.id
  ]

  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "${var.name}-vpce-s3"
  }
}
