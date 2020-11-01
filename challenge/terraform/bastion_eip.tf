resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
    Name    = aws_instance.bastion.tags.Name
    project = aws_instance.bastion.tags.project
  }
}
