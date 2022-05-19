# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "tfe_workspace" "dns" {
  name                  = "dns"
  description           = "Workspace for managing Route53 resources"
  organization          = tfe_organization.beantown.name
  execution_mode        = "local"
  file_triggers_enabled = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["dns"]
  terraform_version     = "1.1.7"
  working_directory     = "dns"
}

resource "tfe_notification_configuration" "dns" {
  name             = "dns-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.dns.id
}
