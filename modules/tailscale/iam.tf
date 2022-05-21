# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "aws_iam_instance_profile" "tailscale_subnet_router" {
  name = "TailscaleSubnetRouter"
  role = aws_iam_role.tailscale_subnet_router_role.name
  tags = {
    Provisioner = "terraform"
    Name        = "TailscaleSubnetRouter"
    RegionCode  = var.region_code
    Role        = "vpn"
  }
}

resource "aws_iam_role" "tailscale_subnet_router_role" {
  name = "TailscaleSubnetRouterRole"
  path = "/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Provisioner = "terraform"
    Name        = "TailscaleSubnetRouterRole"
    RegionCode  = var.region_code
    Role        = "vpn"
  }
}

resource "aws_iam_policy" "tailscale_subnet_router_policy" {
  name        = "TailscaleSubnetRouterPolicy"
  path        = "/"
  description = "Policy for tailscale-subnet-router"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:*",
          "elasticloadbalancing:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage",
          "sts:AssumeRole"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = {
    Provisioner = "terraform"
    Name        = "TailscaleSubnetRouterPolicy"
    RegionCode  = var.region_code
    Role        = "vpn"
  }
}

resource "aws_iam_role_policy_attachment" "tailscale_attachment" {
  role       = aws_iam_role.tailscale_subnet_router_role.name
  policy_arn = aws_iam_policy.tailscale_subnet_router_policy.arn
}
