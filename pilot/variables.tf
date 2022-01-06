variable "dns_zone" {}

variable "env" {
  default = "pilot"
}

variable "k8s_token" {}

variable "local_ip" {
  description = "The public IP of the network a local machine is connected to"
  default     = null
}

variable "ns1_api_key" {}
variable "public_key" {}
