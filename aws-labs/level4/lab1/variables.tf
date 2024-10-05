variable "region" {
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS profile to use"
  default     = "default"
}

variable "vpc_id" {
  description = "VPC ID to deploy resources in"
  type = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs to deploy resources in"
  type        = list(string)
}

variable "proj_name" {
  description = "Name of the Project"
  default     = "devops"
}
