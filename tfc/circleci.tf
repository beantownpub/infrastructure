# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "tfe_workspace" "circleci" {
  name                  = "circleci"
  description           = "Workspace for managing CircleCI variables"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["circleci"]
  terraform_version     = "1.1.3"
  trigger_prefixes      = ["circleci/"]
  working_directory     = "circleci/"
}

resource "tfe_workspace" "circleci_admin" {
  name                  = "circleci_admin"
  description           = "Workspace for managing CircleCI admin project variables"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["circleci", "admin"]
  terraform_version     = "1.1.3"
  trigger_prefixes      = ["circleci/admin/"]
  working_directory     = "circleci/admin/"
}

resource "tfe_workspace" "circleci_beantown" {
  name                  = "circleci_beantown"
  description           = "Workspace for managing CircleCI frontend project variables"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["circleci", "beantown", "frontend"]
  terraform_version     = "1.1.3"
  trigger_prefixes      = ["circleci/beantown/"]
  working_directory     = "circleci/beantown/"
}

resource "tfe_workspace" "circleci_menu_api" {
  name                  = "circleci_menu_api"
  description           = "Workspace for managing CircleCI variables"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["circleci", "menu_api"]
  terraform_version     = "1.1.3"
  trigger_prefixes      = ["circleci/menu_api"]
  working_directory     = "circleci/menu_api"
}

resource "tfe_workspace" "circleci_merch_api" {
  name                  = "circleci_merch_api"
  description           = "Workspace for managing CircleCI variables"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["circleci", "merch_api"]
  terraform_version     = "1.1.3"
  trigger_prefixes      = ["circleci/merch_api"]
  working_directory     = "circleci/merch_api"
}

resource "tfe_variable" "admin_circleci_api_token" {
  key          = "api_token"
  value        = var.admin_circleci_api_token
  category     = "terraform"
  workspace_id = tfe_workspace.circleci_admin.id
  description  = "Admin CircleCI token"
  sensitive    = true
}

resource "tfe_variable" "beantown_circleci_api_token" {
  key          = "api_token"
  value        = var.beantown_circleci_api_token
  category     = "terraform"
  workspace_id = tfe_workspace.circleci_beantown.id
  description  = "Beantown frontend CircleCI token"
  sensitive    = true
}

resource "tfe_variable" "circleci_api_token" {
  key          = "api_token"
  value        = var.circleci_api_token
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Contact API CircleCI token"
  sensitive    = true
}

resource "tfe_variable" "menu_circleci_api_token" {
  key          = "api_token"
  value        = var.menu_circleci_api_token
  category     = "terraform"
  workspace_id = tfe_workspace.circleci_menu_api.id
  description  = "Menu API CircleCI token"
  sensitive    = true
}

resource "tfe_variable" "merch_circleci_api_token" {
  key          = "api_token"
  value        = var.merch_circleci_api_token
  category     = "terraform"
  workspace_id = tfe_workspace.circleci_merch_api.id
  description  = "Merch API CircleCI token"
  sensitive    = true
}

resource "tfe_variable" "circleci_env_api_token" {
  key          = "CIRCLECI_TOKEN"
  value        = var.circleci_api_token
  category     = "env"
  workspace_id = tfe_workspace.circleci.id
  description  = "CircleCI API token"
  sensitive    = true
}

resource "tfe_variable" "test_email_recipient" {
  key          = "test_email_recipient"
  value        = var.test_email_recipient
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Contact API test email recipient"
  sensitive    = false
}

resource "tfe_variable" "google_api_key" {
  key          = "google_api_key"
  value        = var.google_api_key
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Google API token"
  sensitive    = true
}

resource "tfe_variable" "slack_webhook_channel" {
  key          = "slack_webhook_channel"
  value        = var.slack_webhook_channel
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Slack webhook channel"
  sensitive    = false
}

resource "tfe_variable" "slack_orders_channel" {
  key          = "slack_orders_channel"
  value        = var.slack_orders_channel
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Slack orders channel"
  sensitive    = false
}

resource "tfe_variable" "slack_partys_channel" {
  key          = "slack_partys_channel"
  value        = var.slack_partys_channel
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Slack partys channel"
  sensitive    = false
}

resource "tfe_variable" "docker_password" {
  key          = "docker_password"
  value        = var.docker_password
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Docker password"
  sensitive    = true
}

resource "tfe_variable" "docker_username" {
  key          = "docker_username"
  value        = var.docker_username
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Docker username"
  sensitive    = true
}

resource "tfe_notification_configuration" "circleci" {
  name             = "circleci-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.circleci.id
}

resource "tfe_variable" "circleci_aws_access_key_id" {
  key          = "aws_access_key_id"
  value        = var.aws_access_key_id
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "CircleCI AWS key id"
  sensitive    = true
}

resource "tfe_variable" "circleci_aws_secret_access_key" {
  key          = "aws_secret_access_key"
  value        = var.aws_secret_access_key
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "CircleCI AWS secret key"
  sensitive    = true
}

resource "tfe_variable" "jalbot_token" {
  key          = "jalbot_token"
  value        = var.jalbot_token
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Jalbot K8s cluster token"
  sensitive    = true
}

resource "tfe_variable" "k8s_server" {
  key          = "k8s_server"
  value        = var.k8s_server
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "K8s server address URL"
  sensitive    = true
}

resource "tfe_variable" "helm_repo" {
  key          = "helm_repo"
  value        = var.helm_repo
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Helm repository"
  sensitive    = true
}

resource "tfe_variable" "slack_channel" {
  key          = "slack_channel"
  value        = var.slack_channel
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Slack channel for notifications"
  sensitive    = true
}

resource "tfe_variable" "slack_user" {
  key          = "slack_user"
  value        = var.slack_user
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Slack user for sending notifications"
  sensitive    = true
}

resource "tfe_variable" "email_recipient" {
  key          = "email_recipient"
  value        = var.email_recipient
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Email recipient for receiving party request notifications"
  sensitive    = true
}

resource "tfe_variable" "second_email_recipient" {
  key          = "second_email_recipient"
  value        = var.second_email_recipient
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Secondary email recipient for receiving party request notifications"
  sensitive    = true
}

resource "tfe_variable" "support_email_address" {
  key          = "support_email_address"
  value        = var.support_email_address
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Support email address for merch orders"
  sensitive    = true
}

resource "tfe_variable" "support_phone_number" {
  key          = "support_phone_number"
  value        = var.support_phone_number
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Support phone number for merch orders"
  sensitive    = true
}

resource "tfe_variable" "slack_orders_webhook_url" {
  key          = "slack_orders_webhook_url"
  value        = var.slack_orders_webhook_url
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Webhook URL for merch order notifications"
  sensitive    = true
}

resource "tfe_variable" "slack_partys_webhook_url" {
  key          = "slack_partys_webhook_url"
  value        = var.slack_partys_webhook_url
  category     = "terraform"
  workspace_id = tfe_workspace.circleci.id
  description  = "Webhook URL for party request notifications"
  sensitive    = true
}
