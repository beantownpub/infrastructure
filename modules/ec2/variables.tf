
variable "ami" {
  default = null
}

variable "iam_instance_profile_id" {
  type        = string
  description = ""
  default     = null
}

variable "control_name" {}

variable "cluster_name" {
  type        = string
  description = ""
  default     = "prod-use1-cluster"
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

variable "worker_name" {}
variable "env" {}

variable "k8s_token" {}
variable "k8s_version" {
  default = "1.23.0"
}
