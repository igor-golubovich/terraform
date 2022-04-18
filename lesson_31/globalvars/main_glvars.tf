

provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "igoz-bucket"
    key    = "globalvars/terraform.tfstate"
    region = "eu-north-1"
  }
}


#=====================================


output "company_name" {
  value = "igoz_comp"
}

output "owner" {
  value = "igoz"
}

output "tags" {
  value = {
    Project = "XxX"
    Country = "BY"
  }
}
