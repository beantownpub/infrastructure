#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

resource "tfe_variable" "dev" {
  key          = "env"
  value        = "dev"
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "Name of the environment"
}

resource "tfe_variable" "dev_dns_zone" {
  key          = "dns_zone"
  value        = var.dns_zone
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "Name of the environment"
}

resource "tfe_variable" "dev_k8s_token" {
  key          = "k8s_token"
  value        = var.dev_k8s_token
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "dev K8s cluster token"
  sensitive    = true
}

resource "tfe_variable" "dev_public_key" {
  key          = "public_key"
  value        = var.public_key
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "dev K8s public ssh key"
  sensitive    = true
}

resource "tfe_variable" "dev_aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.dev.id
  description  = "dev AWS secret key"
  sensitive    = true
}

resource "tfe_variable" "dev_aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.dev.id
  description  = "dev AWS key id"
  sensitive    = true
}

resource "tfe_variable" "dev_local_ip" {
  key          = "local_ip"
  value        = var.local_ip
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "Public IP of local network"
  sensitive    = true
}

resource "tfe_variable" "dev_region" {
  key          = "region"
  value        = var.dev_region
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "AWS region"
  sensitive    = true
}

resource "tfe_variable" "dev_ns1_api_key" {
  key          = "ns1_api_key"
  value        = var.ns1_api_key
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  description  = "NS1 API key for creating DNS records"
  sensitive    = true
}
