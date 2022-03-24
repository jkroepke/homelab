data "aws_key_pair" "jkr" {
  key_name = "jkr-ed25519"
}

data "aws_ami" "ubuntu2004" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }
}
