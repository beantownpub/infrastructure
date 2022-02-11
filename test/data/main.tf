#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

terraform {
  required_version = "~> 1.1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_cloudfront_distribution" "test" {
  id = "E7T8W4UKDN3JR"
}

data "aws_cloudfront_cache_policy" "test" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_access_identity" "test" {
  id = "E3GY0B8343SOWM"
}

data "aws_cloudfront_origin_request_policy" "test" {
  name = "Managed-AllViewer"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::beantown-static/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_cloudfront_origin_access_identity.test.iam_arn]
    }
  }
}

output "cdn" {
  value = data.aws_cloudfront_distribution.test
}

output "policy" {
  value = data.aws_cloudfront_cache_policy.test
}

output "identity" {
  value = data.aws_cloudfront_origin_access_identity.test
}

output "origin" {
  value = data.aws_cloudfront_origin_request_policy.test
}

output "s3_policy" {
  value = data.aws_iam_policy_document.s3_policy
}
