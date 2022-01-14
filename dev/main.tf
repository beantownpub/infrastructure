terraform {
  cloud {
    organization = "beantown"
    workspaces {
      tags = ["dev", "jal"]
    }
  }
}

module "labels" {
  source = "../modules/labels"

  environment = var.env
  tags        = local.tags
}

locals {
  cluster_name = "${local.env}-${local.region_code}-jalgraves"
  env          = module.labels.environment
  region_code  = module.labels.region_code
  subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
  tags = {
    "Module"      = "terraform-aws-network",
    "Provisioner" = "Terraform"
  }
}

module "network" {
  source  = "app.terraform.io/beantown/network/aws"
  version = "0.1.5"

  allow_ssh_from_ip               = var.local_ip
  availability_zones              = var.availability_zones[data.aws_region.current.name]
  create_ssh_sg                   = true
  default_security_group_deny_all = false
  environment                     = var.env
  cidr_block                      = "10.0.0.0/16"
  internet_gateway_enabled        = true
  label_create_enabled            = true
  nat_gateway_enabled             = false
  nat_instance_enabled            = false
  private_subnets_additional_tags = local.subnet_tags
  public_subnets_additional_tags  = local.subnet_tags
  region_code                     = local.region_code
  tags                            = local.tags
}
