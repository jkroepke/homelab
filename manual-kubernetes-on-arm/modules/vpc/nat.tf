resource "aws_eip" "nat64" {
  vpc = true
}

resource "aws_nat_gateway" "nat64" {
  allocation_id     = aws_eip.nat64.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.dual_stack[data.aws_availability_zones.this.names[0]].id

  depends_on = [aws_internet_gateway.this]
}
