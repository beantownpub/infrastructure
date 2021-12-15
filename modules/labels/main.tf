#
# Jalgraves 2021
#

data "aws_region" "current" {}

locals {
  region_code = var.region_codes[data.aws_region.current.name]
}

module "alb" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes     = ["alb"]
  environment    = var.environment
  labels_as_tags = var.labels_as_tags
  label_order    = var.label_order
  tenant         = local.region_code
  tags           = var.tags
}

module "ec2_control" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes     = ["control"]
  environment    = var.environment
  labels_as_tags = var.labels_as_tags
  label_order    = var.label_order
  tenant         = local.region_code
  tags           = var.tags
}

module "ec2_worker" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes     = ["worker"]
  environment    = var.environment
  labels_as_tags = var.labels_as_tags
  label_order    = var.label_order
  tenant         = local.region_code
  tags           = var.tags
}

module "security_group" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes     = ["k8s", "api", "sg"]
  environment    = var.environment
  labels_as_tags = var.labels_as_tags
  label_order    = var.label_order
  tenant         = local.region_code
  tags           = var.tags
}

module "web_security_group" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes     = ["web", "sg"]
  environment    = var.environment
  labels_as_tags = var.labels_as_tags
  label_order    = var.label_order
  tenant         = local.region_code
  tags           = var.tags
}
