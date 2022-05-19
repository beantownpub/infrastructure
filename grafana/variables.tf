# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

variable "grafana_aws_account_id" {}
variable "grafana_aws_external_id" {}

variable "iam_role_name" {
  type        = string
  default     = "GrafanaLabsCloudWatchIntegration"
  description = "Customize the name of the IAM role used by Grafana for the CloudWatch integration."
}
