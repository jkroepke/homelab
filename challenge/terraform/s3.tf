resource "aws_s3_bucket" "bootstrap" {
  bucket = "${var.name}-bootstrap"
  acl    = "private"

  tags = {
    Name    = "${var.name}-bootstrap"
    project = var.name
  }
}
