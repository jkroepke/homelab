output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.this.name
}

output "iam_role_arn" {
  value = aws_iam_role.this.arn
}
