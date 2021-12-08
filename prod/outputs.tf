output "network" {
  description = ""
  value       = module.network.network
}
output "security" {
  value = module.network.security_group
}

output "ec2_control" {
  value = {
    id        = module.ec2.instance.id
    public_ip = module.ec2.instance.public_ip
  }
}

output "ec2_worker" {
  value = {
    id        = module.ec2.worker.id
    public_ip = module.ec2.worker.public_ip
  }
}
