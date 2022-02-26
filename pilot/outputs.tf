output "validation" {
  value = one(aws_acm_certificate.cert.domain_validation_options[*])
}
output "network" {
  description = ""
  value       = module.network.network
}

output "cluster" {
  value = module.ec2.cluster
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
