provider "aws" {
  region = "us-east-1"  # Change this to your desired region
  profile = "kodek"
}

# Security Group for EC2 Instance
resource "aws_security_group" "datacenter_sg" {
  name        = "datacenter-sg"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "datacenter_ec2" {
  ami                         = var.ami_id  # Replace with a valid Ubuntu AMI ID for your region
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.datacenter_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id = var.subnet_id[0]  # Replace with your subnet ID

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "datacenter-ec2"
  }
}

# ALB
resource "aws_lb" "datacenter_alb" {
  name               = "datacenter-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.subnet_id[0], var.subnet_id[1]]  # Replace with your subnet IDs

  enable_deletion_protection = false
}

# Target Group
resource "aws_lb_target_group" "datacenter_tg" {
  name     = "datacenter-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id  # Replace with your VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "datacenter_alb_listener" {
  load_balancer_arn = aws_lb.datacenter_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.datacenter_tg.arn
  }
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "datacenter_ec2_attachment" {
  target_group_arn = aws_lb_target_group.datacenter_tg.arn
  target_id        = aws_instance.datacenter_ec2.id
  port             = 80
}

