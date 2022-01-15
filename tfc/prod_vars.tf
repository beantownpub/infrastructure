#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

resource "tfe_variable" "prod_public_key" {
  key          = "public_key"
  value        = var.public_key
  category     = "terraform"
  workspace_id = tfe_workspace.prod.id
  description  = "Prod K8s public ssh key"
  sensitive    = true
}

resource "tfe_variable" "prod_aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.prod.id
  description  = "Prod AWS secret key"
  sensitive    = true
}

resource "tfe_variable" "prod_aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.prod.id
  description  = "Prod AWS key id"
  sensitive    = true
}

resource "tfe_variable" "local_ip" {
  key          = "local_ip"
  value        = var.local_ip
  category     = "terraform"
  workspace_id = tfe_workspace.prod.id
  description  = "Public IP of local network"
  sensitive    = true
}

resource "tfe_variable" "prod" {
  key          = "env"
  value        = "prod"
  category     = "terraform"
  workspace_id = tfe_workspace.prod.id
  description  = "Name of the environment"
}

resource "tfe_variable" "prod_dns_zone" {
  key          = "dns_zone"
  value        = var.dns_zone
  category     = "terraform"
  workspace_id = tfe_workspace.prod.id
  description  = "Name of the environment"
}

resource "tfe_variable" "prod_k8s_token" {
  key          = "k8s_token"
  value        = var.prod_k8s_token
  category     = "terraform"
  workspace_id = tfe_workspace.prod.id
  description  = "prod K8s cluster token"
  sensitive    = true
}
