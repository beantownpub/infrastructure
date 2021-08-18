#
# Jalgraves
#

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.3.0"
  name    = var.name
  azs     = var.azs

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  cidr                       = var.cidr
}
