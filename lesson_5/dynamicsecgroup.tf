#--------------------------
# My Terraform
#
# Build Web Server during Bootstrap
#
# Made by igoz
#--------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "dyn_sec_group" {
  name        = "Dynamic Security Group"
  description = "Allow_HTTP_HTTPS_SSH"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092", "9094"]
    content {
      description      = "HTTP"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
