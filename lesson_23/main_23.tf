
provider "aws" {
  region = "eu-north-1"
}

variable "name" {
  default = "vasya"
}

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#S&"
  keepers = {
    kepeer1 = var.name
    //keperr2 = var.something
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master Password for RDS MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.resulpwd
}

data "aws_ssm_parameter" "my_rds_pass" {
  name = "/prod/mysql"

  depends_on = [aws_ssm_parameter.rds_password]
}

output "rds_password" {
  value = nonsensitive(data.aws_ssm_parameter.my_rds_pass.value)
}


// Example of Use Password in RDS
resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "prod"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_pass.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}
