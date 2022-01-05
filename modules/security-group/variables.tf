locals {
  public_ipv4 = var.local_public_ip == null ? [] : ["${var.local_public_ip}/32"]
}

variable "name" {
  description = "Name of the security-group"
  type        = string
  default     = "main"
}

variable "description" {
  description = "K8s API security-group, created via Terraform"
  type        = string
}

variable "web_sg_name" {}

variable "vpc_id" {
  type = string
}

variable "local_public_ip" {
  type        = string
  description = "IP address to allow SSH from"
  default     = null
}

variable "env" {}
variable "region_code" {}
variable "cluster_name" {
  type = string
  description = "Name of cluster to add to tags"
  default = null
}
