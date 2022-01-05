#
# Jalgraves 2021
#

provider "aws" {
  region = "us-east-1"
  #assume_role {
  #  role_arn     = "arn:aws:iam::112138771825:user/jgraves"
  #}
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "beantown"

    workspaces {
      prefix = "jal-"
    }
  }
}

variable "availability_zones" {
  type        = map(any)
  description = ""
  default = {
    us-east-1 = ["us-east-1a", "us-east-1b"]
    us-east-2 = ["us-east-2a", "us-east-2b"]
    us-west-2 = ["us-west-2a", "us-west-2b"]
  }
}
