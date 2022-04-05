data "ct_config" "user_data" {
  content      = local.ignition_user_data
  strict       = true
  pretty_print = false
}

data "ct_config" "config_ign" {
  content      = jsonencode({})
  strict       = true
  pretty_print = true

  snippets = concat(var.snippets, local.file_snippets)

  platform = "ec2"
}

resource "aws_s3_object" "config_ign" {
  bucket  = aws_s3_bucket.this.bucket
  key     = "config.ign"
  content = data.ct_config.config_ign.rendered

  server_side_encryption = "AES256"

  etag        = md5(data.ct_config.config_ign.rendered)
  source_hash = md5(data.ct_config.config_ign.rendered)
}

