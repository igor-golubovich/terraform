
provider "aws" {
  region = "eu-north-1"
}

variable "env" {
  default = "dev"
}

variable "prod_owner" {
  default = "Kolyan"
}

variable "not_prod_owner" {
  default = "Vashkidze"
}


variable "ec2_size" {
  default = {
    "prod"    = "t3.large"
    "dev"     = "t3.micro"
    "staging" = "t3.small"
  }
}



variable "allow_port" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}



resource "aws_instance" "my_webserver" {
  ami = "ami-0f0b4cb72cf3eadf3"
  //instance_type = var.env == "prod" ? "t3.large" : "t3.micro"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}



resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "prod" ? 1 : 0
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = "t3.micro"
  tags = {
    Name = "Bastion-server"
  }
}


resource "aws_instance" "my_web6" {
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = lookup(var.ec2_size, var.env)
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}


resource "aws_security_group" "dyn_sec_group" {
  name        = "Dynamic Security Group"
  description = "Allow_ports_for_${var.env}"

  dynamic "ingress" {
    for_each = lookup(var.allow_port, var.env)
    content {
      description      = "HTTP"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "Dynamic Security Group"
  }
}
