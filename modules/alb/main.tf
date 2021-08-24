#
# Jalgraves 2021
#

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = var.name
  vpc_id = var.vpc_id
  security_groups = var.security_groups
  subnets = var.subnets
  target_groups = var.target_groups
  http_tcp_listeners = var.http_tcp_listeners
}
