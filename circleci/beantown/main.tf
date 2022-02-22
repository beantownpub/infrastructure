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

resource "circleci_environment_variable" "beantown_static_path" {
  name    = "BEANTOWN_STATIC_PATH"
  value   = var.beantown_static_path
  project = "frontend"
}

resource "circleci_environment_variable" "google_api_key" {
  name    = "GOOGLE_API_KEY"
  value   = var.google_api_key
  project = "frontend"
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

resource "circleci_environment_variable" "square_app_id" {
  name    = "SQUARE_APP_ID"
  value   = var.square_app_id
  project = "frontend"
}

resource "circleci_environment_variable" "square_location_id" {
  name    = "SQUARE_LOCATION_ID"
  value   = var.square_location_id
  project = "frontend"
}
