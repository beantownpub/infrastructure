#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

resource "tfe_workspace" "cdn" {
  name                  = "cdn"
  description           = "Workspace for managing CloudFront CDN"
  organization          = tfe_organization.beantown.name
  execution_mode        = "remote"
  file_triggers_enabled = true
  global_remote_state   = true
  queue_all_runs        = true
  speculative_enabled   = true
  tag_names             = ["cdn"]
  terraform_version     = "1.1.3"
  trigger_prefixes      = ["cdn/"]
  working_directory     = "cdn/"
}

resource "tfe_variable" "cdn_aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.cdn.id
  description  = "CDN AWS secret key"
  sensitive    = true
}

resource "tfe_variable" "cdn_aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.cdn.id
  description  = "CDN AWS key id"
  sensitive    = true
}

resource "tfe_notification_configuration" "cdn" {
  name             = "cdn-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:errored", "run:needs_attention", "run:completed"]
  url              = var.slack_webhook_url
  workspace_id     = tfe_workspace.cdn.id
}
