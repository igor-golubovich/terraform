/*

provider "aws" {}


resource "aws_instance" "my_ubuntu" {
  ami           = "ami-0ff338189efb7ed37"
  instance_type = "t3.micro"

  tags = {
    Name    = "ubuntu_machine"
    owner   = "igoz"
    project = "terraform_lesson"
  }
}



resource "aws_instance" "my_amazon_linux" {
  ami           = "ami-0d441f5643da997cb"
  instance_type = "t3.micro"

  tags = {
    Name    = "amazon_machine"
    owner   = "igoz"
    project = "terraform_lesson"
  }
}


*/
