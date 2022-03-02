# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

terraform {
  required_version = "~> 1.1.3"
  required_providers {
    circleci = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
  cloud {
    organization = "beantown"
    workspaces {
      name = "dns"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
