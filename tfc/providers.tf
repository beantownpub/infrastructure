# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.27.0"
    }
  }
  cloud {
    organization = "beantown"

    workspaces {
      name = "tfc"
    }
  }
}

provider "tfe" {
  token = var.tfc_token
}
