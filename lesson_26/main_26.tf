#
#  lesson_26
#
#  Создание ресурсов в нескольких AWS Regions и Accounts
#

provider "aws" {
  region = "eu-north-1"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "Frankfurt"
}

provider "aws" {
  region = "ca-central-1"
  alias  = "Canada"
}

data "aws_ami" "ami_lat_amz_fr" {
  provider    = aws.Frankfurt
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*x86_64-gp2"]
  }
}



data "aws_ami" "ami_lat_amz_can" {
  provider    = aws.Canada
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*x86_64-gp2"]
  }
}


resource "aws_instance" "my_serv_stc" {
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = "t3.micro"
  tags = {
    Name = "Default_server_stc"
  }
}


resource "aws_instance" "my_serv_fr" {
  provider      = aws.Frankfurt
  ami           = data.aws_ami.ami_lat_amz_fr.id
  instance_type = "t3.micro"
  tags = {
    Name = "Default_server_fr"
  }
}



resource "aws_instance" "my_serv_canada" {
  provider      = aws.Canada
  ami           = data.aws_ami.ami_lat_amz_can.id
  instance_type = "t3.micro"
  tags = {
    Name = "Default_server_canada"
  }
}
