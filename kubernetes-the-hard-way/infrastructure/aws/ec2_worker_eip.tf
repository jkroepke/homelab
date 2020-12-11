resource "aws_eip" "worker_eip" {
  for_each = aws_instance.worker

  instance = each.value.id
  vpc      = true

  tags = {
    Name    = each.value.tags.Name
    project = each.value.tags.project
  }
}
