variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "primary_key" {
  description = "The primary key of the DynamoDB table"
  type        = string
}

variable "tasks" {
  description = "The list of tasks to be added to the DynamoDB table"
  type        = list(object({
    task_id     = string
    description = string
    status      = string
  }))
}