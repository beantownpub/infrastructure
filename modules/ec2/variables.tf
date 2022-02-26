# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

locals {
  app_versions = {
    cilium = "1.10.5"
    istio  = "1.12.1"
    k8s    = "1.23.0"
  }
}
variable "ami" {
  default = null
}

variable "iam_instance_profile_id" {
  type        = string
  description = ""
  default     = null
}

variable "control_name" {}

variable "domain_name" {}

variable "cluster_name" {
  type        = string
  description = ""
  default     = "jalgraves-cluster"
}
variable "private_subnets" {
  default = []
}
variable "security_groups" {
  default = []
}
variable "region_code" {
  default = "use1"
}
variable "subnets" {
  type        = list(string)
  description = ""
  default     = []
}

variable "tags" {
  type        = map(string)
  description = ""
  default     = {}
}

variable "env" {}

variable "k8s_token" {}
variable "public_key" {}
variable "worker_name" {}
