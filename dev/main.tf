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

module "web_sg" {
  source = "../modules/security-group/"
  name = "web-sg"
  description = "fuck you asshole"
  vpc_id = module.vpc.vpc_id
}
