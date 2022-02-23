# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

data "tfe_workspace" "tfc" {
  name         = "tfc"
  organization = "beantown"
}

resource "tfe_variable" "github_oauth_token" {
  key          = "github_oauth_token"
  value        = var.github_oauth_token
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "GitHub OAuth token"
  sensitive    = true
}

resource "tfe_variable" "slack_webhook_url" {
  key          = "slack_webhook_url"
  value        = var.slack_webhook_url
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "Slack webhook URL"
  sensitive    = true
}
