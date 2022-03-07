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

output "databases" {
  value = {
    merch_api = {
      host     = var.merch_api_db_host
      name     = var.merch_api_db_name
      username = var.merch_api_db_username
      password = var.merch_api_db_password
    },
    menu_api = {
      host     = var.menu_api_db_host
      name     = var.menu_api_db_name
      username = var.menu_api_db_username
      password = var.menu_api_db_password
    }
  }
  sensitive = true
}

output "api_creds" {
  value = {
    merch_api = {
      username = var.merch_api_username
      password = var.merch_api_password
    },
    menu_api = {
      username = var.menu_api_username
      password = var.menu_api_password
    }
  }
  sensitive = true
}

output "slack" {
  value = {
    webhook_url = var.slack_webhook_url
  }
}
