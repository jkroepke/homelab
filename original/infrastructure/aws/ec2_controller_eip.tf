resource "aws_eip" "controller_eip" {
  for_each = aws_instance.controller

  instance = each.value.id
  vpc      = true

  tags = {
    Name    = each.value.tags.Name
    project = each.value.tags.project
  }
}
