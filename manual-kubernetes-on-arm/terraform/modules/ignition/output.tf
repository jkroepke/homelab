output "user_data" {
  value = data.ct_config.user_data.rendered
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
