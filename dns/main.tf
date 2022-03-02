# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "aws_route53_zone" "main" {
  name    = "aws.jalgraves.com"
  comment = "Development zone delegated from Google DNS. Created via Terraform"

  tags = {
    Provisioner = "Terraform"
  }
}

resource "aws_route53_record" "dev" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dev.${aws_route53_zone.main.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["prod-use1-alb-1669079694.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dev_wildcard" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "*.dev.${aws_route53_zone.main.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["prod-use1-alb-1669079694.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "foo" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "foo.aws.jalgraves.com"
  type    = "A"

  alias {
    name                   = "prod-use1-alb-1669079694.us-east-1.elb.amazonaws.com"
    zone_id                = "Z35SXDOTRQ7X7K"
    evaluate_target_health = false
  }
  allow_overwrite = true
}

# resource "aws_route53_zone" "subdomains" {
#   for_each = toset( ["dev", "pilot"] )
#   name     = "${each.key}.${aws_route53_zone.main.name}"
# }

# resource "aws_route53_record" "ns" {
#   for_each = toset( ["dev", "pilot"] )
#   zone_id = aws_route53_zone.main.zone_id
#   name = "${each.key}.${aws_route53_zone.main.name}"
#   type    = "NS"
#   ttl     = "300"
#   records = each.value.name_servers
# }
