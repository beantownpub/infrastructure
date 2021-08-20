terraform {
  required_version = "~> 1.0.5"
  required_providers {
    aws = {
      version = "3.54.0"
    }
  }
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

module "web_sg" {
  source = "../modules/security-group/"
  name = "web-sg"
  description = "Security group for web ingress"
  vpc_id = module.vpc.vpc_id
}
