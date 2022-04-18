#
#
#
# 19. Использование Переменных - variables
#
#
#

provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amz_lin" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*x86_64-gp2"]
  }
}

resource "aws_eip" "my_eip_amz_lin" {
  instance = aws_instance.my_server_lin.id

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} my_eip_amz_lin" })
}

/*
  tags = {
    Name  = "my_eip_amz_lin"
  }
}

*/

resource "aws_instance" "my_server_lin" {
  ami                    = data.aws_ami.latest_amz_lin.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_sec_gr_lin.id]
  monitoring             = var.enable_detailed_monitoring

  tags = merge(var.common_tags, { Name = "my_server_lin" })

}

resource "aws_security_group" "my_sec_gr_lin" {
  name = "my_sec_gr_lin"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "my_sec_gr_lin" })

}
