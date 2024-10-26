# ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.proj_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  # Use the default subnets
  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = ["${aws_security_group.ecs_sg.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "${var.proj_name}-container"
    container_port   = 80
  }
}
