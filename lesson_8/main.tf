#--------------------------
# My Terraform
#
# Made by igoz
#--------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "my_amz_web" {
  ami                    = "ami-0d441f5643da997cb" # Amazon Linux ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_amz_web.id]

  tags = {
    Name = "my_amz_web"
  }
  depends_on = [aws_instance.my_amz_bd, aws_instance.my_amz_app]
}

resource "aws_instance" "my_amz_app" {
  ami                    = "ami-0d441f5643da997cb" # Amazon Linux ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_amz_web.id]

  tags = {
    Name = "my_amz_app"
  }
  depends_on = [aws_instance.my_amz_bd]
}

resource "aws_instance" "my_amz_bd" {
  ami                    = "ami-0d441f5643da997cb" # Amazon Linux ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_amz_web.id]

  tags = {
    Name = "my_amz_db"
  }
}

resource "aws_security_group" "my_amz_web" {
  name        = "my_amz_web"
  description = "Allow_HTTP_HTTPS_SSH"


  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
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
    Name = "my_amz_web"
  }
}
