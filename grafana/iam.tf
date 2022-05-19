# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

data "aws_iam_policy_document" "trust_grafana" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.grafana_aws_account_id}:root"]
    }

    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.grafana_aws_external_id]
    }
  }
}

resource "aws_iam_role" "grafana_labs_cloudwatch_integration" {
  name        = var.iam_role_name
  description = "Role used by Grafana CloudWatch integration."

  # Allow Grafana Labs' AWS account to assume this role.
  assume_role_policy = data.aws_iam_policy_document.trust_grafana.json

  # This policy allows the role to discover metrics via tags and export them.
  inline_policy {
    name = var.iam_role_name
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "tag:GetResources",
            "cloudwatch:*",
            "logs:*"
          ]
          Resource = "*"
        }
      ]
    })
  }
}
