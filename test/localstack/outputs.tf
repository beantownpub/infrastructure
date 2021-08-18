#
# Copyright:: Copyright (c) 2021 HqO.
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
#


output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "VPC CIDR"
}

output "vpc_main_route_table_id" {
  value       = module.vpc.vpc_main_route_table_id
  description = "VPC main route table"
}

output "availability_zones" {
  value       = module.subnets.availability_zones
  description = "Availability zones"
}

output "private_subnet_ids" {
  value       = module.subnets.private_subnet_ids
  description = "Private subnet IDs"
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "Private subnet CIDRS"
}

output "public_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "Public subnet CIDRS"
}
