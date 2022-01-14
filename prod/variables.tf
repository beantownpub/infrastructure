#        **       **       **           ********    *******         **       **      **   ********    ********
#       /**      ****     /**          **//////**  /**////**       ****     /**     /**  /**/////    **//////
#       /**     **//**    /**         **      //   /**   /**      **//**    /**     /**  /**        /**
#       /**    **  //**   /**        /**           /*******      **  //**   //**    **   /*******   /*********
#       /**   **********  /**        /**    *****  /**///**     **********   //**  **    /**////    ////////**
#   **  /**  /**//////**  /**        //**  ////**  /**  //**   /**//////**    //****     /**               /**
#  //*****   /**     /**  /********   //********   /**   //**  /**     /**     //**      /********   ********
#   /////    //      //   ////////     ////////    //     //   //      //       //       ////////   ////////

variable "availability_zones" {
  type        = map(any)
  description = ""
  default = {
    us-east-1 = ["us-east-1a", "us-east-1b"]
    us-east-2 = ["us-east-2a", "us-east-2b"]
    us-west-2 = ["us-west-2a", "us-west-2b"]
  }
}

variable "dns_zone" {
  description = "domain name with ssl cert"
}

variable "k8s_token" {}

variable "local_ip" {
  description = "The public IP of the network a local machine is connected to"
  default     = null
}

variable "public_key" {}
