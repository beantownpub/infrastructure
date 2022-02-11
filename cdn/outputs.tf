#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

output "cdn" {
  value = {
    bucket        = aws_s3_bucket.beantown_static
    bucket_policy = aws_s3_bucket_policy.beantown_static.policy
    oai           = aws_cloudfront_origin_access_identity.beantown_static
    distribution = {
      aliases             = aws_cloudfront_distribution.beantown_static.aliases
      arn                 = aws_cloudfront_distribution.beantown_static.arn
      domain_name         = aws_cloudfront_distribution.beantown_static.domain_name
      default_root_object = aws_cloudfront_distribution.beantown_static.default_root_object
      hosted_zone_id      = aws_cloudfront_distribution.beantown_static.hosted_zone_id
    }
  }
}
