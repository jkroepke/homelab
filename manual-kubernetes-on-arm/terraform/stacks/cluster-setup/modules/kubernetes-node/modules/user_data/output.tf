output "bucket_arn" {
  value = module.ignition.bucket_arn
}

output "rendered" {
  value = module.ignition.user_data
}
