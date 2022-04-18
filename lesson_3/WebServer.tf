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


resource "aws_instance" "my_webserver" {
  ami                    = "ami-0d441f5643da997cb" # Amazon Linux ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("user_data.sh")

  tags = {
    Name = "Amazon_Linux_WebServer"
  }
}



resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Allow_HTTP_HTTPS_SSH"


  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
    Name = "WebServer Security Group"
  }
}
