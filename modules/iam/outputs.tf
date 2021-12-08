output "iam_instance_profile_id" {
  value = aws_iam_instance_profile.default.id
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.default.arn
}

output "iam_role_id" {
  value = aws_iam_role.default.id
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}
