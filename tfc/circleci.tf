#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

resource "tfe_workspace" "circleci" {
  name                  = "circleci"
  description           = "Workspace for managing CloudFront CDN"
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

resource "tfe_variable" "circleci_api_token" {
  key          = "api_token"
  value        = var.circleci_api_token
  category     = "terraform"
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

resource "tfe_notification_configuration" "circleci" {
  name             = "circleci-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.circleci.id
}
