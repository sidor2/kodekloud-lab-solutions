provider "aws" {
  region = "us-east-1" # Change the region if necessary
  profile = "kodek"
}

resource "aws_dynamodb_table" "kodek_tasks" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = var.primary_key

  attribute {
    name = var.primary_key
    type = "S"  # String type
  }

  tags = {
    Name = var.table_name
  }
}

resource "aws_dynamodb_table_item" "task" {
  for_each   = { for task in var.tasks : task.task_id => task }
  table_name = aws_dynamodb_table.kodek_tasks.name
  hash_key   = aws_dynamodb_table.kodek_tasks.hash_key

  item = jsonencode({
    taskId      = { S = each.value.task_id }
    description = { S = each.value.description }
    status      = { S = each.value.status }
  })
}

