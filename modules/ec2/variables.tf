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
  cluster_name = var.cluster_name == null ? "${var.env}-cluster" : var.cluster_name
  k8s_server   = "k8s.${var.env}.${var.domain}"
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
  description = "Name of the K8s cluster"
  default     = null
}
variable "cluster_cidr" {
  default = "10.96.0.0/12"
}
variable "domain" {
  default = "beantownpub.com"
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
