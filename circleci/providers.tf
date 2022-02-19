# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

terraform {
  required_version = "~> 1.1.3"
  required_providers {
    circleci = {
      source  = "mrolla/circleci"
      version = "0.6.1"
    }
  }
  cloud {
    organization = "beantown"
    workspaces {
      name = "circleci"
    }
  }
}

provider "circleci" {
  api_token    = var.api_token
  vcs_type     = "github"
  organization = "beantown"
}
