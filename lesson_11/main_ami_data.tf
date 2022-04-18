#
# автопоиск ami_id с помощью data source

# ubuntu | amazon_linux | windows_server
#
#

provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "ami_latest_ubuntu_20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

output "ami_latest_ubuntu_20_ami" {
  value = data.aws_ami.ami_latest_ubuntu_20.id
}

output "ami_latest_ubuntu_20_name" {
  value = data.aws_ami.ami_latest_ubuntu_20.name
}



data "aws_ami" "ami_latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*x86_64-gp2"]
  }
}

output "ami_latest_amazon_linux_ami" {
  value = data.aws_ami.ami_latest_amazon_linux.id
}

output "ami_latest_amazon_linux_name" {
  value = data.aws_ami.ami_latest_amazon_linux.name
}




data "aws_ami" "ami_latest_windows_server_2019" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

output "ami_latest_windows_server_2019_ami" {
  value = data.aws_ami.ami_latest_windows_server_2019.id
}

output "ami_latest_windows_server_2019_name" {
  value = data.aws_ami.ami_latest_windows_server_2019.name
}
