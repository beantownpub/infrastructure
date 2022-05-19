# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "tfe_workspace" "grafana" {
  name                  = "grafana"
  description           = "Workspace for managing grafana"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["grafana"]
  terraform_version     = "1.1.7"
  trigger_prefixes      = ["grafana/"]
  working_directory     = "grafana/"
}

resource "tfe_variable" "aws_account_id" {
  key          = "aws_account_id"
  value        = var.aws_account_id
  category     = "terraform"
  workspace_id = tfe_workspace.grafana.id
  description  = "AWS account ID"
  sensitive    = true
}

resource "tfe_variable" "grafana_api_key" {
  key          = "grafana_api_key"
  value        = var.grafana_api_key
  category     = "terraform"
  workspace_id = tfe_workspace.grafana.id
  description  = "grafana API Key"
  sensitive    = true
}

resource "tfe_variable" "grafana_aws_account_id" {
  key          = "grafana_aws_account_id"
  value        = var.grafana_aws_account_id
  category     = "terraform"
  workspace_id = tfe_workspace.grafana.id
  description  = "Grafana AWS account ID"
  sensitive    = false
}

resource "tfe_variable" "grafana_aws_external_id" {
  key          = "grafana_aws_external_id"
  value        = var.grafana_aws_external_id
  category     = "terraform"
  workspace_id = tfe_workspace.grafana.id
  description  = "Grafana AWS external ID"
  sensitive    = true
}

resource "tfe_notification_configuration" "grafana" {
  name             = "grafana-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:planning", "run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.grafana.id
}

resource "tfe_variable" "grafana_aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.grafana.id
  description  = "grafana AWS secret key"
  sensitive    = true
}

resource "tfe_variable" "grafana_aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.grafana.id
  description  = "grafana AWS key id"
  sensitive    = true
}
