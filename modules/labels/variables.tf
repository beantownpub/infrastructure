#
#
#

variable "region_codes" {
  type = map(any)
  default = {
    us-east-1 = "use1"
    us-east-2 = "use2"
    us-west-2 = "usw2"
  }
}

variable "environment" {}
variable "labels_as_tags" {
  default = ["environment", "name", "attributes"]
}
variable "label_order" {
  default = ["environment", "tenant", "name", "attributes"]
}
variable "tags" {
  default = {}
}
