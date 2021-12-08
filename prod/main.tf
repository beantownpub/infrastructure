data "aws_region" "current" {}
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "beantown"

    workspaces {
      prefix = "jal-"
    }
  }
}
locals {
  tags = {
    "Module"      = "terraform-aws-network",
    "Provisioner" = "Terraform"
  }
}

module "network" {
  source  = "app.terraform.io/beantown/network/aws"
  version = "0.1.0"

  allow_ssh_from_ip               = "50.231.13.130"
  availability_zones              = ["us-west-2a", "us-west-2b"]
  create_ssh_sg                   = true
  default_security_group_deny_all = true
  environment                     = "dev"
  cidr_block                      = "10.0.0.0/16"
  internet_gateway_enabled        = true
  label_create_enabled            = true
  nat_gateway_enabled             = false
  nat_instance_enabled            = false
  tags                            = local.tags
}

module "iam" {
  source = "../modules/iam"

  iam_instance_profile_name = "ClusterNode"
  iam_role_name             = "prod-usw2-cluster-node-iam-role"
  tags                      = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "prod-usw2-sg"
  vpc_id      = module.network.vpc_id
  description = "Security group for web traffic created via Terraform"
}

module "ec2" {
  source = "../modules/ec2"

  name            = "prod-usw2-ec2-control"
  subnets         = module.network.public_subnet_ids
  security_groups = [module.network.security_group.id, module.security_group.security_group_id]
}


#module "alb" {
#  source          = "../modules/alb/"
#  name            = "prod-usw2-alb"
#  vpc_id          = module.network.vpc_id
#  subnets         = module.network.public_subnet_ids
#  security_groups = [module.network.security_group.id, module.security_group.security_group_id]
#  description     = "ALB for Beantown Pub"
#}
