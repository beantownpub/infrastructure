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

resource "tfe_variable" "menu_api_db_host" {
  key          = "menu_api_db_host"
  value        = var.menu_api_db_host
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "menu API DB host"
  sensitive    = true
}

resource "tfe_variable" "menu_api_db_username" {
  key          = "menu_api_db_username"
  value        = var.menu_api_db_username
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "menu API DB username"
  sensitive    = true
}

resource "tfe_variable" "menu_api_db_password" {
  key          = "menu_api_db_password"
  value        = var.menu_api_db_password
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "menu API DB password"
  sensitive    = true
}

resource "tfe_variable" "menu_api_db_name" {
  key          = "menu_api_db_name"
  value        = var.menu_api_db_name
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "menu API DB name"
  sensitive    = true
}

resource "tfe_variable" "menu_api_username" {
  key          = "menu_api_username"
  value        = var.menu_api_username
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "menu API username"
  sensitive    = true
}

resource "tfe_variable" "menu_api_password" {
  key          = "menu_api_password"
  value        = var.menu_api_password
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "menu API password"
  sensitive    = true
}

resource "tfe_variable" "merch_api_db_host" {
  key          = "merch_api_db_host"
  value        = var.merch_api_db_host
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "Merch API DB host"
  sensitive    = true
}

resource "tfe_variable" "merch_api_db_username" {
  key          = "merch_api_db_username"
  value        = var.merch_api_db_username
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "Merch API DB username"
  sensitive    = true
}

resource "tfe_variable" "merch_api_db_password" {
  key          = "merch_api_db_password"
  value        = var.merch_api_db_password
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "Merch API DB password"
  sensitive    = true
}

resource "tfe_variable" "merch_api_db_name" {
  key          = "merch_api_db_name"
  value        = var.merch_api_db_name
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "Merch API DB name"
  sensitive    = true
}

resource "tfe_variable" "merch_api_username" {
  key          = "merch_api_username"
  value        = var.merch_api_username
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "Merch API username"
  sensitive    = true
}

resource "tfe_variable" "merch_api_password" {
  key          = "merch_api_password"
  value        = var.merch_api_password
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "Merch API password"
  sensitive    = true
}

resource "tfe_notification_configuration" "tfc" {
  name             = "tfc-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = data.tfe_workspace.tfc.id
}
