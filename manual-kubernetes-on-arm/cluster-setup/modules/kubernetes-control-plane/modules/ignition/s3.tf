resource "aws_s3_bucket" "this" {
  bucket = "${var.cluster_name}-ignition-configs-controller${var.index}"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.bucket
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  restrict_public_buckets = true

  block_public_acls   = true
  block_public_policy = true

  ignore_public_acls = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_object" "files_vars" {
  for_each = var.additional_files

  bucket  = aws_s3_bucket.this.bucket
  key     = each.key
  content = each.value.content

  server_side_encryption = "AES256"

  etag        = md5(each.value.content)
  source_hash = md5(each.value.content)
}

resource "aws_s3_object" "files_module" {
  for_each = { for file in local.files_modules_list : "/${file}" => templatefile("${path.module}/files/${file}", {
    cluster_dns = var.cluster_dns
    pod_cidr    = var.pod_cidr
  }) }

  bucket  = aws_s3_bucket.this.bucket
  key     = each.key
  content = each.value

  server_side_encryption = "AES256"

  etag        = md5(each.value)
  source_hash = md5(each.value)
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.iam_instance_role]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}
