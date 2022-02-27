# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

terraform {
  required_version = ">= 1.1.3"
  required_providers {
    circleci = {
      source  = "TomTucka/circleci"
      version = "0.5.0"
    }
  }
  cloud {
    organization = "beantown"
    workspaces {
      name = "circleci_menu_api"
    }
  }
}

provider "circleci" {
  vcs_type     = "github"
  organization = "beantownpub"
}
