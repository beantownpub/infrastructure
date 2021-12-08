

variable "iam_instance_profile_id" {
  type        = string
  description = ""
  default     = null
}

variable "name" {}
variable "security_groups" {
  default = []
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
