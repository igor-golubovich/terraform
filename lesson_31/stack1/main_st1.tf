

provider "aws" {
  region = "eu-north-1"
}



data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "igoz-bucket"
    key    = "globalvars/terraform.tfstate"
    region = "eu-north-1"
  }
}


locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  owner        = data.terraform_remote_state.global.outputs.owner
  common_tags  = data.terraform_remote_state.global.outputs.tags
}

resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/24"
  tags = {
    Name    = "vpc1_les31"
    Company = local.company_name
    Owner   = local.owner
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block = "192.168.10.0/24"
  tags       = merge(local.common_tags, { Name = "vpc2_les31" })
}
