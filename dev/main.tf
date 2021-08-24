terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "beantown"

    workspaces {
      prefix = "jal-"
    }
  }
}

module "vpc" {
  source = "../modules/vpc/"
  name = "main"
}

module "acm" {
  source = "../modules/acm/"
  domain_name = "jalgraves.com"
  validation_method = "EMAIL"
}

module "web_sg" {
  source = "../modules/security-group/"
  name = "web-sg"
  description = "Security group for web ingress"
  vpc_id = module.vpc.vpc_id
}
