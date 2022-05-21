# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "tfe_workspace" "tailscale" {
  name                  = "tailscale"
  description           = "Workspace for managing tailscale"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["tailscale"]
  terraform_version     = var.terraform_version
  trigger_prefixes      = ["tailscale/"]
  working_directory     = "tailscale/"
}

resource "tfe_variable" "vpc_id" {
  key          = "vpc_id"
  value        = var.vpc_id
  category     = "terraform"
  workspace_id = tfe_workspace.tailscale.id
  description  = "VPC ID"
  sensitive    = true
}

resource "tfe_notification_configuration" "tailscale" {
  name             = "tailscale-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:planning", "run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.tailscale.id
}

resource "tfe_variable" "tailscale_public_key" {
  key          = "public_key"
  value        = var.public_key
  category     = "terraform"
  workspace_id = tfe_workspace.tailscale.id
  description  = "tailscale K8s public ssh key"
  sensitive    = true
}

resource "tfe_variable" "tailscale_aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.tailscale.id
  description  = "tailscale AWS secret key"
  sensitive    = true
}

resource "tfe_variable" "tailscale_aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.tailscale.id
  description  = "tailscale AWS key id"
  sensitive    = true
}
