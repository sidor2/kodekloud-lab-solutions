provider "aws" {
  region  = var.region
  profile = var.profile
}

# Create a Security Group to allow HTTP traffic
resource "aws_security_group" "kodek_sg" {
  name        = "${var.proj_name}-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.kodek_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name}-sg"
  }
}

# Create the Launch Template
resource "aws_launch_template" "kodek_launch_template" {
  name_prefix = "${var.proj_name}-launch-template"
  image_id    = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  

  key_name = "${var.proj_name}-key"

  # Security Group for the EC2 Instances
  vpc_security_group_ids = [aws_security_group.kodek_sg.id]
  
#   network_interfaces {
#     associate_public_ip_address = false
#     security_groups = [aws_security_group.kodek_sg.id]
#   }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1 -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
    )

  tags = {
    Name = "${var.proj_name}-ec2"
  }
}

# Fetch Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create the Auto Scaling Group
resource "aws_autoscaling_group" "kodek_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  launch_template {
    id      = aws_launch_template.kodek_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [aws_lb_target_group.kodek_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.proj_name}-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Auto Scaling Policy based on CPU Utilization
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu_policy"
  policy_type            = "TargetTrackingScaling"   # Set the correct policy type
  estimated_instance_warmup = 300

  autoscaling_group_name = aws_autoscaling_group.kodek_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0  # Set the target CPU utilization to 50%
  }
}


# Create the Target Group for ALB
resource "aws_lb_target_group" "kodek_tg" {
  name     = "${var.proj_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

data "aws_security_group" "kodek_sg_data" {
  name = "${var.proj_name}-sg"
}

# create a security group for the ALB that allows traffic on port 80
resource "aws_security_group" "kodek_alb_sg" {
  name        = "${var.proj_name}-alb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [data.aws_security_group.kodek_sg_data.id]
  }

  tags = {
    Name = "${var.proj_name}-alb-sg"
  }
  
}

# Create the Application Load Balancer
resource "aws_lb" "kodek_alb" {
  name               = "${var.proj_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.kodek_alb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.proj_name}-alb"
  }
}

# Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.kodek_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kodek_tg.arn
  }
}

