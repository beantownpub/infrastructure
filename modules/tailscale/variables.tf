# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022
variable "ami" {
  type    = string
  default = null
}
variable "public_key" {
  type = string
}
variable "region_code" {
  type = string
}
variable "security_group_ids" {
  type = list(string)
}
variable "subnets" {
  type = list(any)
}
variable "subnets_to_advertise" {
  type    = string
  default = null
}
variable "tailscale_auth_key" {
  type = string
}
variable "vpc_id" {
  type = string
}
