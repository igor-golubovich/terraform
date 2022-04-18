

provider "aws" {
  region = "eu-north-1"
}

variable "aws_users" {
  description = "List of users for AWS"
  default     = ["vasya", "galya", "samvel", "gregory", "glasha", "vovan", "petro", "sanya"]
}





resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}


output "created_iam_users" {
  value = aws_iam_user.users
}


output "created_iam_users_id" {
  value = aws_iam_user.users[*].id
}

output "created_aim_users_custom" {
  value = [
    for i in aws_iam_user.users :
    "Username: ${i.id} has ARN ${i.arn}"
  ]
}


output "created_iam_users_map" {
  value = {
    for j in aws_iam_user.users :
    j.unique_id => j.id
  }
}

output "custom_1" {
  value = [
    for x in aws_iam_user.users :
    x.id
    if length(x.id) == 5
  ]
}

/*

resource "aws_instance" "my_servers" {
  count         = 3
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = "t3.micro"
  tags = {
    Name = "Server number ${count.index + 1}"
  }
}

output "servers" {
  value = {
    for y in aws_instance.my_servers :
    y.id => y.public_ip
  }
}

*/
