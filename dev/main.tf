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
