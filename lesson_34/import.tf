provider "aws" {
  region = "eu-north-1"
}


resource "aws_instance" "node1" {
  ami                    = "ami-001c5f3c0a8b3f245"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-09d1cc4dff4928c4e", "sg-0c77624a56f65dc43"]
  tags = {
    Name  = "node1"
    Owner = "igoz"
  }
}


resource "aws_instance" "node2" {
  ami                    = "ami-001c5f3c0a8b3f245"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-09d1cc4dff4928c4e", "sg-0c77624a56f65dc43"]
  tags = {
    Name  = "node2"
    Owner = "igoz"
  }
}

# resource "aws_instance" "node3" {
#   ami                    = "ami-001c5f3c0a8b3f245"
#   instance_type          = "t3.micro"
#   vpc_security_group_ids = ["sg-09d1cc4dff4928c4e", "sg-0c77624a56f65dc43", aws_security_group.new_sc.id]
#   tags = {
#     Name  = "node3"
#     Owner = "igoz"
#   }
# }
#
#
#
# resource "aws_security_group" "new_sc" {
#   description = "new_sc"
#   tags = {
#     Name = "new_sc"
#   }
# }
