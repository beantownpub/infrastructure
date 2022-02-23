# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

data "terraform_remote_state" "tfc" {
  backend = "remote"
  config = {
    organization = "beantown"
    workspaces = {
      name = "tfc"
    }
  }
}

resource "circleci_environment_variable" "docker_username" {
  name    = "DOCKER_USERNAME"
  value   = data.terraform_remote_state.tfc.outputs.docker.username
  project = "contact_api"
}

resource "circleci_environment_variable" "docker_password" {
  name    = "DOCKER_PASSWORD"
  value   = data.terraform_remote_state.tfc.outputs.docker.password
  project = "contact_api"
}

resource "circleci_environment_variable" "helm_repo" {
  name    = "HELM_REPO"
  value   = data.terraform_remote_state.tfc.outputs.k8s.helm_repo
  project = "frontend"
}

resource "circleci_environment_variable" "jalbot_token" {
  name    = "JALBOT_TOKEN"
  value   = data.terraform_remote_state.tfc.outputs.k8s.jalbot_token
  project = "frontend"
}

resource "circleci_environment_variable" "k8s_server" {
  name    = "K8S_SERVER"
  value   = data.terraform_remote_state.tfc.outputs.k8s.server
  project = "frontend"
}
