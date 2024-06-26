resource "aws_s3_bucket" "this" {
  bucket = "${var.name}-ssm"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  restrict_public_buckets = true

  block_public_acls   = true
  block_public_policy = true

  ignore_public_acls = true
}
