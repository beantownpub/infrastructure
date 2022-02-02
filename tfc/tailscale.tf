#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
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
  terraform_version     = "1.1.3"
  trigger_prefixes      = ["tailscale/"]
  working_directory     = "tailscale/"
}

resource "tfe_variable" "tailscale_api_key" {
  key          = "tailscale_api_key"
  value        = var.tailscale_api_key
  category     = "env"
  workspace_id = tfe_workspace.tailscale.id
  description  = "Tailscale API Key"
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
