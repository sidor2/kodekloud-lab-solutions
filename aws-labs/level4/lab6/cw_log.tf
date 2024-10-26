resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.proj_name}-logs"
  retention_in_days = 7  # Adjust the retention period as needed
}
