variable "domain_name" {
  description = "The domain name for the cert"
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Zone ID"
  type        = string
  default     = null
}

variable "subject_alternative_names" {
  description = "Alternative names for certificate"
  type        = list(string)
  default     = []
}

variable "create_certificate" {
  description = "Whether or not to attempt create cert"
  type        = bool
  default     = false
}

variable "validation_method" {
  description = "Method for validating cert. DNS, EMAIL, or NONE"
  type        = string
  default     = "NONE"
}

variable "wait_for_validation" {
  description = "Whether or not to wait for cert to be validated"
  type        = bool
  default     = false
}
