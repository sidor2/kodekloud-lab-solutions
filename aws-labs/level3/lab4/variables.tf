variable "profile" {
  description = "AWS profile name"
  default = "default"
  type = string
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type = string
}

variable "task_name" {
  description = "Name of the ECS task"
  type = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type = list(string)
}
