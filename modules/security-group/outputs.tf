output "internal_cluster_traffic" {
  value = aws_security_group.internal_cluster_traffic
}

output "web_traffic" {
  value       = aws_security_group.web_traffic
  description = "Security group created"
}

output "local_machine_traffic" {
  description = ""
  value       = one(aws_security_group.local_machine_traffic[*])
}
