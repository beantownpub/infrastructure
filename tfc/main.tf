#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

resource "tfe_organization" "beantown" {
  name  = "beantown"
  email = "jalgraves@gmail.com"
}

resource "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.beantown.name
}

resource "tfe_workspace" "dev" {
  name              = "dev"
  description       = "Workspace for dev infrastructure"
  organization      = tfe_organization.beantown.name
  execution_mode    = "remote"
  tag_names         = ["dev"]
  terraform_version = "1.1.3"
  working_directory = "dev"
  vcs_repo {
    branch             = "master"
    identifier         = "beantownpub/infrastructure"
    ingress_submodules = false
    oauth_token_id     = var.github_oauth_token
  }
}

resource "tfe_workspace" "pilot" {
  name              = "pilot"
  description       = "Workspace for pilot infrastructure"
  organization      = tfe_organization.beantown.name
  execution_mode    = "remote"
  tag_names         = ["pilot"]
  terraform_version = "1.1.3"
  working_directory = "pilot"
  vcs_repo {
    branch             = "master"
    identifier         = "beantownpub/infrastructure"
    ingress_submodules = false
    oauth_token_id     = var.github_oauth_token
  }
}

resource "tfe_workspace" "prod" {
  name                  = "prod"
  description           = "Workspace for prod infrastructure"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["prod"]
  terraform_version     = "1.1.3"
  working_directory     = "prod"
  vcs_repo {
    branch             = "master"
    identifier         = "beantownpub/infrastructure"
    ingress_submodules = false
    oauth_token_id     = var.github_oauth_token
  }
}

resource "tfe_workspace" "dns" {
  name                  = "dns"
  description           = "Workspace for managing Route53 resources"
  organization          = tfe_organization.beantown.name
  execution_mode        = "local"
  file_triggers_enabled = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["dns"]
  terraform_version     = "1.1.3"
  working_directory     = "dns"
}

resource "tfe_notification_configuration" "dns" {
  name             = "dns-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:planning", "run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.dns.id
}

resource "tfe_notification_configuration" "pilot" {
  name             = "pilot-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:planning", "run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.pilot.id
}

resource "tfe_notification_configuration" "tfc" {
  name             = "tfc-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:planning", "run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = data.tfe_workspace.tfc.id
}
