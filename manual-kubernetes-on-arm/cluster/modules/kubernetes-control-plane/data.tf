data "aws_caller_identity" "current" {}

data "aws_key_pair" "jkr" {
  key_name = "jkr-ed25519"
}

data "aws_ami" "flatcar" {
  most_recent = true
  owners      = ["aws-marketplace"]

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
