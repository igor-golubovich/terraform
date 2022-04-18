

provider "aws" {
  region = "eu-north-1"
}


terraform {
  backend "s3" {
    bucket = "igoz-bucket"
    key    = "dev/severs/terraform.tfstate"
    region = "eu-north-1"
  }
}

#============================================

variable "env" {
  default = "dev"
}


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "igoz-bucket"
    key    = "dev/network/terraform.tfstate"
    region = "eu-north-1"
  }
}

data "aws_ami" "ami_latest_amz_lin" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*x86_64-gp2"]
  }
}


resource "aws_security_group" "my_sg" {
  name   = "SG_lesson_27"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id


  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.network.outputs.vpc_cidr]
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
    Name = "${var.env}_SG"
  }
}


resource "aws_instance" "my_serv" {
  ami                    = data.aws_ami.ami_latest_amz_lin.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_sub_id[0]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
  tags = {
    Name = "${var.env}_SERV"
  }
}


output "network_details" {
  value = data.terraform_remote_state.network
}


output "web_sg_id" {
  value = aws_security_group.my_sg.id
}


output "web_ip_public" {
  value = aws_instance.my_serv.public_ip
}
