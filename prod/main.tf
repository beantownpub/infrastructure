terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "beantown"

    workspaces {
      name = "prod"
    }
  }
}

module "vpc" {
  source = "../modules/vpc/"
  name = "main"
}
