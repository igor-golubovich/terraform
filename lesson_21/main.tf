#
#  lesson_20
#
#  local variables
#

provider "aws" {
  region = "eu-north-1"
}


data "aws_region" "current" {}
data "aws_availability_zones" "az" {}


locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
  az_list           = join(",", data.aws_availability_zones.az.names)
}


resource "aws_eip" "my_static_ip" {
  tags = {
    Name       = "static_ip"
    Owner      = local.project_owner
    Project    = local.full_project_name
    region_azs = local.az_list
  }
}
