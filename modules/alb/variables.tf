variable "name" {
  description = "Name of the ALB"
  type = string
  default = "main"
}

variable "description" {
  description = "Description of ALB"
  type = string
}

variable "vpc_id" {
  description = "vpc ID"
  type = string
}

variable "security_groups" {
  description = "The security groups to attach the ALB"
  type = list(string)
  default = []
}

variable "subnets" {
  description = "A list of subnets to associate with the ALB"
  type = list(string)
  default = []
}

variable "target_groups" {
  description = "A list of maps that define the target groups to be created"
  type = any
  default = []
}
