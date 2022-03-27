data "ct_config" "this" {
  content      = file("${path.module}/resources/ignition/os.yaml")
  strict       = true
  pretty_print = false

  snippets = concat([
    templatefile("${path.module}/resources/ignition/kubernetes.yaml", {
      version = var.kubernetes_version
    })
  ], local.files_modules, local.files_additional_files, local.files_templates)

  platform = "ec2"

  depends_on = [
    aws_s3_object.module,
    aws_s3_object.templates,
    aws_s3_object.additional_files,
  ]
}
