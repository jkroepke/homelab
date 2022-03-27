locals {
  files_modules_list = fileset("${path.module}/resources/files", "**/*")

  files_modules = [for filename in local.files_modules_list : templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
    path   = "/${filename}",
    bucket = aws_s3_bucket.this.bucket
    mode   = "0644"
    user   = "root"
    group  = "root"
  })]
}

resource "aws_s3_object" "module" {
  for_each = { for filename in local.files_modules_list : "/${filename}" => file("${path.module}/resources/files/${filename}") }

  bucket  = aws_s3_bucket.this.bucket
  key     = each.key
  content = each.value

  server_side_encryption = "AES256"

  etag        = md5(each.value)
  source_hash = md5(each.value)
}
