#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

data "tfe_workspace" "tfc" {
  name         = "tfc"
  organization = "beantown"
}

resource "tfe_variable" "dev" {
  key          = "env"
  value        = "dev"
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "Name of the environment"
}

resource "tfe_variable" "github_oauth_token" {
  key          = "github_oauth_token"
  value        = var.github_oauth_token
  category     = "terraform"
  workspace_id = data.tfe_workspace.tfc.id
  description  = "GitHub OAuth token"
  sensitive    = true
}
