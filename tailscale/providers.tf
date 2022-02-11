#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

terraform {
  cloud {
    organization = "beantown"

    workspaces {
      name = "tailscale"
    }
  }
}

terraform {
  required_providers {
    tailscale = {
      source  = "davidsbond/tailscale"
      version = "0.7.0"
    }
  }
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = "jalgraves.github"
}

provider "aws" {
  region = var.region
}
