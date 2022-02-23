# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "tfe_organization_membership" "jalgraves" {
  organization = "beantown"
  email        = "jalgraves@gmail.com"
}

resource "tfe_organization_membership" "jalbot" {
  organization = "beantown"
  email        = "jalgraves@yahoo.com"
}

resource "tfe_team_organization_member" "jalgraves" {
  team_id                    = tfe_team.owners.id
  organization_membership_id = tfe_organization_membership.jalgraves.id
}

resource "tfe_team_organization_member" "jalbot" {
  team_id                    = tfe_team.owners.id
  organization_membership_id = tfe_organization_membership.jalbot.id
}
