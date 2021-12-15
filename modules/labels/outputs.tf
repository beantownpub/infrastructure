#
#
#
output "alb" {
  value = {
    name = module.alb.id
    tags = module.alb.tags
  }
}

output "ec2_control" {
  value = {
    name = module.ec2_control.id
    tags = module.ec2_control.tags
  }
}

output "ec2_worker" {
  value = {
    name = module.ec2_worker.id
    tags = module.ec2_worker.tags
  }
}

output "security_group" {
  value = {
    name = module.security_group.id
    tags = module.security_group.tags
  }
}

output "web_security_group" {
  value = {
    name = module.web_security_group.id
    tags = module.web_security_group.tags
  }
}

output "environment" {
  value = var.environment
}

output "region_code" {
  value = local.region_code
}
