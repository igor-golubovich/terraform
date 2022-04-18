#--------------------------
# My Terraform
#
# for Terraform Worksopace
#
# Made by igoz
#--------------------------


resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = {
    Name = "for_ws -${terraform.workspace}"
  }
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0d441f5643da997cb" # Amazon Linux ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.for_ws.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Igor",
    l_name = "Golubovich",
    names  = ["Vasya", "Kolya", "Petya", "John", "Mascha"]
  })

  tags = {
    Name = "Amazon_Linux_WebServer - ${terraform.workspace}"
  }
}



resource "aws_security_group" "for_ws" {
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
    Name = "for_ws - ${terraform.workspace}"
  }
}


output "web_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}
