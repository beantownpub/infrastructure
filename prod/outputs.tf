output "network" {
  description = ""
  value       = module.network.network
}
output "security" {
  value = module.security
}

output "ec2_control" {
  value = {
    id         = module.ec2.instance.id
    public_ip  = module.ec2.instance.public_ip
    private_ip = module.ec2.instance.private_ip
  }
}

output "ec2_worker" {
  value = {
    id         = module.ec2.worker.id
    public_ip  = module.ec2.worker.public_ip
    private_ip = module.ec2.worker.private_ip
  }
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "iam" {
  value = module.iam
}
