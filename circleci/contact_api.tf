# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "circleci_environment_variable" "aws_access_key_id" {
  name    = "AWS_ACCESS_KEY_ID"
  value   = var.aws_access_key_id
  project = "contact_api"
}

resource "circleci_environment_variable" "aws_secret_access_key" {
  name    = "AWS_SECRET_ACCESS_KEY"
  value   = var.aws_secret_access_key
  project = "contact_api"
}

resource "circleci_environment_variable" "aws_region" {
  name    = "AWS_DEFAULT_REGION"
  value   = "us-east-2"
  project = "contact_api"
}

resource "circleci_environment_variable" "docker_username" {
  name    = "DOCKER_USERNAME"
  value   = var.docker_username
  project = "contact_api"
}

resource "circleci_environment_variable" "docker_password" {
  name    = "DOCKER_PASSWORD"
  value   = var.docker_password
  project = "contact_api"
}

resource "circleci_environment_variable" "test_email_recipient" {
  name    = "TEST_EMAIL_RECIPIENT"
  value   = var.test_email_recipient
  project = "contact_api"
}

resource "circleci_environment_variable" "email_recipient" {
  name    = "EMAIL_RECIPIENT"
  value   = var.email_recipient
  project = "contact_api"
}

resource "circleci_environment_variable" "second_email_recipient" {
  name    = "SECOND_EMAIL_RECIPIENT"
  value   = var.second_email_recipient
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_webhook_channel" {
  name    = "SLACK_WEBHOOK_CHANNEL"
  value   = var.slack_webhook_channel
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_webhook_url" {
  name    = "SLACK_WEBHOOK_URL"
  value   = data.terraform_remote_state.tfc.outputs.slack.webhook_url
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_orders_channel" {
  name    = "SLACK_ORDERS_CHANNEL"
  value   = var.slack_orders_channel
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_orders_webhook_url" {
  name    = "SLACK_ORDERS_WEBHOOK_URL"
  value   = var.slack_orders_webhook_url
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_partys_webhook_url" {
  name    = "SLACK_PARTYS_WEBHOOK_URL"
  value   = var.slack_partys_webhook_url
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_channel" {
  name    = "SLACK_CHANNEL"
  value   = var.slack_channel
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_user" {
  name    = "SLACK_USER"
  value   = var.slack_user
  project = "contact_api"
}

resource "circleci_environment_variable" "slack_partys_channel" {
  name    = "SLACK_PARTYS_CHANNEL"
  value   = var.slack_partys_channel
  project = "contact_api"
}

resource "circleci_environment_variable" "support_email_address" {
  name    = "SUPPORT_EMAIL_ADDRESS"
  value   = var.support_email_address
  project = "contact_api"
}

resource "circleci_environment_variable" "support_phone_number" {
  name    = "SUPPORT_PHONE_NUMBER"
  value   = var.support_phone_number
  project = "contact_api"
}

resource "circleci_environment_variable" "contact_api_log_level" {
  name    = "LOG_LEVEL"
  value   = "INFO"
  project = "contact_api"
}



resource "circleci_environment_variable" "jalbot_token" {
  name    = "JALBOT_TOKEN"
  value   = var.jalbot_token
  project = "contact_api"
}

resource "circleci_environment_variable" "k8s_server" {
  name    = "K8S_SERVER"
  value   = var.k8s_server
  project = "contact_api"
}

resource "circleci_environment_variable" "helm_repo" {
  name    = "HELM_REPO"
  value   = var.helm_repo
  project = "contact_api"
}
