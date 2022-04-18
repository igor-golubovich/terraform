#
#
# variables for main_variablws.tf
#
#

variable "region" {
  description = "Please enter AWS_Region"
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "Please enter AWS_instance_type"
  default     = "t3.small"
}

variable "ingress_ports" {
  description = "Please enter allowed ingress_ports"
  default     = ["80", "443", "22", "8080"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(any)
  default = {
    Owner      = "igoz"
    Project    = "terra_xxx"
    CostCenter = "6665666"
    Enviroment = "development"
  }
}
