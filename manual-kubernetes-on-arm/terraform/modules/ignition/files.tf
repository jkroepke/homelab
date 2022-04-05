locals {
  file_snippets = [for filename, options in var.files : jsonencode({
    storage = {
      files = [
        {
          path       = filename
          filesystem = "rootfs"
          mode       = options.mode
          user       = { name = options.user }
          group      = { name = options.group }
          contents = { remote = {
            url          = "s3://${aws_s3_bucket.this.bucket}${filename}",
            verification = { hash = { function = "sha512", sum = sha512(options.content) } }
          } }
        }
      ]
    }
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
