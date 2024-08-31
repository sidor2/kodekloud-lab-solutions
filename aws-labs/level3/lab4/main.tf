provider "aws" {
  region = "us-east-1"
  profile = var.profile
}

# Create a private ECR repository
resource "aws_ecr_repository" "kodekloud_ecr" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
}

# Run Docker commands to build and push the image
resource "null_resource" "docker_build_and_push" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region us-east-1 --profile ${var.profile} | docker login --username AWS --password-stdin ${aws_ecr_repository.kodekloud_ecr.repository_url}
      cd pyapp/
      docker build -t ${var.repository_name}:latest .
      docker tag ${var.repository_name}:latest ${aws_ecr_repository.kodekloud_ecr.repository_url}:latest
      docker push ${aws_ecr_repository.kodekloud_ecr.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.kodekloud_ecr]
}

# Create ECS Cluster
resource "aws_ecs_cluster" "kodekloud_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRoleTest"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}


resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.task_name}"
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "kodekloud_taskdefinition" {
  family                   = var.task_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }

  container_definitions = jsonencode([{
    name  = "kodekloud-container"
    image = "${aws_ecr_repository.kodekloud_ecr.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
      appProtocol   = "http"
      name          = "nginx-80-tcp"
    }]
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.task_name}"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  depends_on = [ aws_iam_role.ecsTaskExecutionRole, null_resource.docker_build_and_push, aws_ecr_repository.kodekloud_ecr, aws_ecs_cluster.kodekloud_cluster, aws_cloudwatch_log_group.ecs_log_group ]
}


resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_security_group"
  description = "Allow outbound access to ECR"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows inbound access from any IP address
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows outbound access to any IP address (including ECR)
  }

  tags = {
    Name = "ecs_security_group"
  }
}

# Create ECS Service
resource "aws_ecs_service" "kodekloud_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.kodekloud_cluster.id
  task_definition = aws_ecs_task_definition.kodekloud_taskdefinition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [ aws_security_group.ecs_security_group.id ]
    assign_public_ip = true
  }

  depends_on = [ aws_ecs_task_definition.kodekloud_taskdefinition ]
}
