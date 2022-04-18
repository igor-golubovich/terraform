provider "aws" {
  region = "eu-north-1"
}

resource "null_resource" "my_command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"

  }
}

resource "null_resource" "my_command2" {
  provisioner "local-exec" {
    command = "ping -c 4 www.google.com"

  }
}

resource "null_resource" "my_command3" {
  provisioner "local-exec" {
    command     = "print('Hello World!')"
    interpreter = ["python", "-c"]
  }
}

resource "null_resource" "my_command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> name.txt"
    environment = {
      NAME1 = "Olya"
      NAME2 = "Petya"
      NAME3 = "Sasha"
    }
  }
}

resource "aws_instance" "my_inst" {
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS"
  }
}


resource "null_resource" "my_command5" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"

  }
  depends_on = [null_resource.my_command1, null_resource.my_command2, null_resource.my_command3, null_resource.my_command4, aws_instance.my_inst]
}
