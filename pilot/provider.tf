#
# Jalgraves 2022
#

provider "aws" {
  region = "us-west-2"
}

terraform {
  cloud {
    organization = "beantown"

    workspaces {
      name = "jal-pilot"
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
