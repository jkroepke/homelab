resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name = "${var.name}-nat"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id     = aws_eip.this.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public[data.aws_availability_zones.this.names[0]].id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${var.name}-nat"
  }
}
