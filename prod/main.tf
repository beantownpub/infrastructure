terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "beantown"

    workspaces {
      prefix = "prod-"
    }
  }
}

module "vpc" {
  source = "../modules/vpc/"
  name = "main"
}
