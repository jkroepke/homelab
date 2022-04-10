data "aws_key_pair" "jkr" {
  key_name = var.key_name
}

data "aws_ami" "flatcar" {
  most_recent = true
  owners      = ["075585003325"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["Flatcar-alpha-*"]
  }
}
