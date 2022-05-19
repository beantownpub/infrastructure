# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "tfe_organization" "beantown" {
  name  = "beantown"
  email = "jalgraves@gmail.com"
}

resource "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.beantown.name
}
