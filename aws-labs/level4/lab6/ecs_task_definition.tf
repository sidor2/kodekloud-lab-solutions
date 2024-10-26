# ECS Task Definition with inline container definitions
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.proj_name}-ecs-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "${var.proj_name}-container"
    image     = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "FLASK_ENV"
        value = "development"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.proj_name}-logs"
        "awslogs-region"        = "${var.region}"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}