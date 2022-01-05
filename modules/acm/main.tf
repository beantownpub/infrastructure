module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = var.domain_name
  zone_id     = var.zone_id

  subject_alternative_names = var.subject_alternative_names

  validation_method   = var.validation_method
  wait_for_validation = var.wait_for_validation

  tags = {
    Name = var.domain_name
  }
}
