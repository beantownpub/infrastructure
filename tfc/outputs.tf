# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

output "aws" {
  value = {
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
  }
  sensitive = true
}

output "circleci_tokens" {
  value = {
    admin    = var.admin_circleci_api_token
    beantown = var.beantown_circleci_api_token
  }
  sensitive = true
}

output "k8s" {
  value = {
    helm_repo    = var.helm_repo
    jalbot_token = var.jalbot_token
    server       = var.k8s_server
  }
  sensitive = true
}

output "docker" {
  value = {
    username = var.docker_username
    password = var.docker_password
  }
  sensitive = true
}

output "slack" {
  value = {
    webhook_url = var.slack_webhook_url
  }
}
