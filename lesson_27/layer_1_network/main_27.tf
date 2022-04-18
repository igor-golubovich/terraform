
provider "aws" {
  region = "eu-north-1"
}


terraform {
  backend "s3" {
    bucket = "igoz-bucket"
    key    = "dev/network/terraform.tfstate"
    region = "eu-north-1"
  }
}



#==================================================


variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "dev"
}

variable "pub_sub_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}


#==================================================

data "aws_availability_zones" "available" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env} - VPC"
  }
}

resource "aws_internet_gateway" "my_gate" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.env} - igw"
  }
}


resource "aws_subnet" "public_sub" {
  count                   = length(var.pub_sub_cidrs)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = element(var.pub_sub_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env} - public_${count.index + 1}"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gate.id
  }
  tags = {
    Name = "${var.env} - route_table"
  }
}

resource "aws_route_table_association" "pub_route_sub" {
  count          = length(aws_subnet.public_sub[*].id)
  route_table_id = aws_route_table.public_route.id
  subnet_id      = element(aws_subnet.public_sub[*].id, count.index)
}

#==========================================


output "vpc_id" {
  value = aws_vpc.my_vpc.id
}


output "vpc_cidr" {
  value = aws_vpc.my_vpc.cidr_block
}


output "public_sub_id" {
  value = aws_subnet.public_sub[*].id
}
