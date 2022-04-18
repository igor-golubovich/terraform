provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "igoz-bucket"
    key    = "prod/terraform.tfstate"
    region = "eu-north-1"
  }
}
