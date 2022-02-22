# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

locals {
  s3_origin_id = "BeantownOrigin"
}

data "aws_acm_certificate" "prod" {
  domain   = "prod.beantownpub.com"
  statuses = ["ISSUED"]
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.beantown_static.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.beantown_static.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "beantown_static" {
  bucket = "static.prod.beantownpub.com"
  acl    = "private"

  tags = {
    Environment = "prod"
    Name        = "static.prod.beantownpub.com"
    Role        = "cdn"
  }
}

resource "aws_s3_bucket_policy" "beantown_static" {
  bucket = aws_s3_bucket.beantown_static.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_origin_access_identity" "beantown_static" {
  comment = "beantown-static-oai"
}

resource "aws_cloudfront_distribution" "beantown_static" {
  aliases             = ["static.prod.beantownpub.com"]
  comment             = "Beantown CDN. Created via Terraform"
  default_root_object = ""
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  wait_for_deployment = false
  tags = {
    Environment = "prod"
    RegionCode  = "use1"
    Role        = "cdn"
  }

  origin {
    domain_name = aws_s3_bucket.beantown_static.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.beantown_static.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern           = "/img/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = local.s3_origin_id
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern           = "/css/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.prod.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
