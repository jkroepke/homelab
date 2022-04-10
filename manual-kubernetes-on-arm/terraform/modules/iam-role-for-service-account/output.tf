output "role_arn" {
  value = aws_iam_role.this.arn
}

output "kubernetes_config_env" {
  value = local.env
}

output "kubernetes_config_env_flat" {
  value = { for env in local.env : env.name => env.value }
}

output "kubernetes_config_extra_volumes" {
  value = local.extraVolumes
}

output "kubernetes_config_extra_volume_mounts" {
  value = local.extraVolumeMounts
}
