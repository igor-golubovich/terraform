variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "dev"
}

variable "public_subnet_cidrs" {
  default = [
    "10.31.1.0/24",
    "10.32.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.311.0/24",
    "10.0.322.0/24"
  ]
}
