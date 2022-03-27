locals {
  files_var = [for filename, options in var.files : templatefile("${path.module}/templates/parts/file_remote.yaml", {
    path   = filename,
    bucket = aws_s3_bucket.this.bucket
    mode   = options.mode
    user   = options.user
    group  = options.group
  })]

  files_modules_list = fileset("${path.module}/files", "**/*")

  files_modules = [for file in local.files_modules_list :
    templatefile("${path.module}/templates/parts/file_remote.yaml", {
      path   = "/${file}",
      bucket = aws_s3_bucket.this.bucket
      mode   = "0644"
      user   = "root"
      group  = "root"
    })
  ]
}

data "ct_config" "this" {
  content      = file("${path.module}/templates/os.yaml")
  strict       = true
  pretty_print = false

  snippets = concat([
    templatefile("${path.module}/templates/kubernetes.yaml", {
      version = var.kubernetes_version
    })
  ], local.files_var, local.files_modules)

  platform = "ec2"

  depends_on = [aws_s3_object.files_vars, aws_s3_object.files_module]
}
