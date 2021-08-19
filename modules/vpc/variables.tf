#
# Copyright:: Copyright (c) 2021 Jalgraves.
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
#

variable "name" {
  description = "Name of the VPC"
  type = string
  default = "main"
}

variable "azs" {
  description = "Availability zones to put subnets in"
  type = list
  default = ["us-east-1a", "us-east-1b"]
}

variable "cidr" {
  description = "CIDR network space for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "region" {
  description = "value"
  type = string
  default = "us-east-1"
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway in VPC"
  type = bool
  default = false
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway in VPC"
  type = bool
  default = false
}

variable "public_subnets" {
  description = "Public subnets"
  type = list
  default = ["10.0.101.0/24"]
}

variable "private_subnets" {
  description = "Private subnets"
  type = list
  default = ["10.0.1.0/24"]
}
