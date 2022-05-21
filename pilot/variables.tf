# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

variable "availability_zones" {
  type        = map(any)
  description = "AWS availability zones to use for subnets in selected regions"
  default = {
    us-east-1 = ["us-east-1a", "us-east-1b"]
    us-east-2 = ["us-east-2a", "us-east-2b"]
    us-west-2 = ["us-west-2a", "us-west-2b"]
  }
}

variable "dns_zone" {
  type        = string
  description = "Root domain name used for hosts and certs"
}

variable "env" {
  default = "pilot"
}

variable "k8s_token" {
  type        = string
  description = "Token used by nodes to join K8s cluster"
}

variable "local_ip" {
  description = "The public IP of the network a local machine is connected to"
  default     = null
}

variable "ns1_api_key" {
  type        = string
  description = "NS1 API key used to create CNAMEs for SSL cert verification"
}

variable "public_key" {
  type        = string
  description = "SSH public key"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}
variable "tailscale_api_key" {}
