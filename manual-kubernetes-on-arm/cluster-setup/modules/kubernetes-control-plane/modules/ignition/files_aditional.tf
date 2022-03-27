locals {
  files_additional_files = [for filename, options in var.additional_files : templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
    path   = filename,
    bucket = aws_s3_bucket.this.bucket
    mode   = options.mode
    user   = options.user
    group  = options.group
  })]
}

resource "aws_s3_object" "additional_files" {
  for_each = var.additional_files

  bucket  = aws_s3_bucket.this.bucket
  key     = each.key
  content = each.value.content

  server_side_encryption = "AES256"

  etag        = md5(each.value.content)
  source_hash = md5(each.value.content)
}
