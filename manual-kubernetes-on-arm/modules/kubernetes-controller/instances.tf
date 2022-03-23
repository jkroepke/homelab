resource "aws_instance" "this" {
  for_each = var.subnets

  ami               = data.aws_ami.ubuntu2004.id
  availability_zone = each.key
  ebs_optimized     = true

  credit_specification {
    cpu_credits = "standard"
  }

  key_name             = data.aws_key_pair.jkr.key_name
  instance_type        = "t4g.micro"
  iam_instance_profile = var.iam_instance_profile_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted             = true
    volume_size           = 30
    delete_on_termination = true

    tags = {
      project = var.project_name
    }
  }

  subnet_id              = each.value
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = "${var.project_name}-controller-${each.key}"
  }
}
