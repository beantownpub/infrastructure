
output "instance" {
  description = ""
  value       = aws_instance.control
}

output "worker" {
  description = ""
  value       = aws_instance.worker
}

output "cluster" {
  value = {
    name = local.cluster_name
  }
}
