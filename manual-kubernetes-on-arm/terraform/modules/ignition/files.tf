locals {
  file_snippets = [for filename, options in var.files : templatefile("${path.module}/snippets/files_url.yaml", {
    path   = filename,
    mode   = options.mode,
    user   = options.user,
    group  = options.group,
    bucket = aws_s3_bucket.this.bucket,
    hash   = sha512(options.content)
  })]
}

resource "aws_s3_object" "this" {
  for_each = var.files

  bucket  = aws_s3_bucket.this.bucket
  key     = each.key
  content = each.value.content

  server_side_encryption = "AES256"

  etag        = md5(each.value.content)
  source_hash = md5(each.value.content)
}
