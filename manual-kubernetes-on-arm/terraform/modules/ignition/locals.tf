locals {
  ignition_config_source = "s3://${aws_s3_object.config_ign.bucket}/${aws_s3_object.config_ign.key}"
  ignition_config_hash   = sha512(data.ct_config.config_ign.rendered)
  ignition_user_data = jsonencode({
    ignition = {
      config = {
        replace = {
          source = local.ignition_config_source
          verification = {
            hash = { function = "sha512", sum = local.ignition_config_hash }
          }
        }
      }
    }
  })
}
