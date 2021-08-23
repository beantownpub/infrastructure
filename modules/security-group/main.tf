#
# Jalgraves 2021
#

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name = var.name
  vpc_id = var.vpc_id
  description = var.description
}
