#
# Jalgraves 2021
#

# NOTE: You need MFA associated with the account creaating these resources
# Make sure mfa_serial exists in .aws/config under profile creating resources

resource "aws_iam_instance_profile" "worker" {
  name = "K8sWorker"
  role = aws_iam_role.worker.name
}

resource "aws_iam_instance_profile" "control_plane" {
  name = "K8sControlPlane"
  role = aws_iam_role.control_plane.name
}

resource "aws_iam_role" "worker" {
  name = "K8sWorkerRole"
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
  tags = var.tags
}

resource "aws_iam_role" "control_plane" {
  name = "K8sControlPlaneRole"
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
  tags = var.tags

}

resource "aws_iam_policy" "worker_policy" {
  name        = "K8sWorkerPolicy"
  path        = "/"
  description = "Policy for K8s worker nodes"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:*",
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
}

resource "aws_iam_policy" "control_plane_policy" {
  name        = "K8sControlPlanePolicy"
  path        = "/"
  description = "Policy for K8s control plane nodes"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:*",
          "iam:CreateServiceLinkedRole",
          "kms:DescribeKey"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_attachment" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.worker_policy.arn
}

resource "aws_iam_role_policy_attachment" "control_plane_attachment" {
  role       = aws_iam_role.control_plane.name
  policy_arn = aws_iam_policy.control_plane_policy.arn
}
