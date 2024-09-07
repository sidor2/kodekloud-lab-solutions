provider "aws" {
  region = var.region
  profile = var.profile
}

# Existing EC2 Instance
# Get EC2 Instance ID by name tag
data "aws_instance" "kodek_ec2" {
  filter {
    name   = "tag:Name"
    values = [var.ec2_instance_name]
  }
}

data "aws_security_group" "kodek_ec2_sg" {
  name = "${tolist(data.aws_instance.kodek_ec2.security_groups)[0]}"
}

# # RDS Security Group to allow access from EC2 on port 3306 (MySQL) and port 80
resource "aws_security_group" "rds_sg" {
  name = "rds_security_group"

  ingress {
    description = "Allow MySQL access from EC2 instance"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      "${data.aws_security_group.kodek_ec2_sg.id}"
    ]
  }
}

# # RDS instance creation
resource "aws_db_instance" "kodek_rds" {
  identifier              = var.rds_identifier
  allocated_storage       = 5
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.36"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_admin
  password                = var.db_password
  publicly_accessible     = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
}


resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.kodek_ec2_sg.id  # Replace with your security group ID
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.kodek_ec2_sg.id  # Replace with your security group ID
}
