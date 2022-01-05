output "worker_iam_instance_profile_id" {
  value = aws_iam_instance_profile.worker.id
}

output "control_plane_iam_instance_profile_id" {
  value = aws_iam_instance_profile.control_plane.id
}
output "worker_iam_instance_profile_arn" {
  value = aws_iam_instance_profile.worker.arn
}

output "worker_iam_role_id" {
  value = aws_iam_role.worker.id
}

output "worker_iam_role_arn" {
  value = aws_iam_role.worker.arn
}

output "control_plane_iam_role_id" {
  value = aws_iam_role.control_plane.id
}

output "control_plane_iam_role_arn" {
  value = aws_iam_role.control_plane.arn
}
