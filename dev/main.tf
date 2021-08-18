terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "beantown"

    workspaces {
      name = "dev"
    }
  }
}

module "vpc" {
  source = "../modules/vpc/"
  name = "main"
}
