#
#
#  lesson_18
#
#  create Web servers with Zero downtime and Green/Blue deployment
#
#
# Provision Highly Availabe Web in any Region Default VPC
# Create:
#    - Security Group for Web Server
#    - Launch Configuration with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
#
#

provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "az" {}

data "aws_ami" "ami_latest_amz_lin" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*x86_64-gp2"]
  }
}


resource "aws_security_group" "web_sg" {
  name = "web_sg"
  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
  tags = {
    Name  = "web_sg"
    Owner = "igoz"
  }
}


resource "aws_launch_configuration" "web_lc" {

  #name            = "web_lc"
  name_prefix     = "web_lc-"
  image_id        = data.aws_ami.ami_latest_amz_lin.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web_sg.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "asg-${aws_launch_configuration.web_lc.name}"
  launch_configuration = aws_launch_configuration.web_lc.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web_lb.name]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG"
      Owner  = "igoz"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web_lb" {
  name               = "web-lb"
  availability_zones = [data.aws_availability_zones.az.names[0], data.aws_availability_zones.az.names[1]]
  security_groups    = [aws_security_group.web_sg.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "web_lb"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.az.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.az.names[1]
}

#--------------------------------------------------
output "web_loadbalancer_url" {
  value = aws_elb.web_lb.dns_name
}
