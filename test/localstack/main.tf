#
# Copyright:: Copyright (c) 2021 HqO.
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
#

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.25.0"

  cidr_block                       = "172.16.0.0/16"
  context                          = module.this.context
  assign_generated_ipv6_cidr_block = false
}

module "subnets" {
  source = "cloudposse/dynamic-subnets/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version            = "0.39.3"
  availability_zones = var.availability_zones
  # availability_zones   = []
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = "172.16.0.0/16"
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  context              = module.this.context
  tags = {
    Provisioner : "terratest"
  }
}
