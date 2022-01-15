#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

resource "tfe_variable" "pilot" {
  key          = "env"
  value        = "pilot"
  category     = "terraform"
  workspace_id = tfe_workspace.pilot.id
  description  = "Name of the environment"
}

resource "tfe_variable" "pilot_dns_zone" {
  key          = "dns_zone"
  value        = var.dns_zone
  category     = "terraform"
  workspace_id = tfe_workspace.pilot.id
  description  = "Name of the environment"
}

resource "tfe_variable" "pilot_k8s_token" {
  key          = "k8s_token"
  value        = var.pilot_k8s_token
  category     = "terraform"
  workspace_id = tfe_workspace.pilot.id
  description  = "pilot K8s cluster token"
  sensitive    = true
}

resource "tfe_variable" "pilot_public_key" {
  key          = "public_key"
  value        = var.public_key
  category     = "terraform"
  workspace_id = tfe_workspace.pilot.id
  description  = "pilot K8s public ssh key"
  sensitive    = true
}

resource "tfe_variable" "pilot_aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.pilot.id
  description  = "pilot AWS secret key"
  sensitive    = true
}

resource "tfe_variable" "pilot_aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.pilot.id
  description  = "pilot AWS key id"
  sensitive    = true
}

resource "tfe_variable" "pilot_local_ip" {
  key          = "local_ip"
  value        = var.local_ip
  category     = "terraform"
  workspace_id = tfe_workspace.pilot.id
  description  = "Public IP of local network"
  sensitive    = true
}

resource "tfe_variable" "pilot_region" {
  key          = "region"
  value        = var.pilot_region
  category     = "terraform"
  workspace_id = tfe_workspace.pilot.id
  description  = "AWS region"
  sensitive    = true
}

resource "tfe_variable" "pilot_ns1_api_key" {
  key          = "ns1_api_key"
  value        = var.ns1_api_key
  category     = "terraform"
  workspace_id = tfe_workspace.pilot.id
  description  = "NS1 API key for creating DNS records"
  sensitive    = true
}
