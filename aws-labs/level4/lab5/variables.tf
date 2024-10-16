variable "region" {
  description = "AWS region"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "v" {
  description = "Policy version"
  type        = string
}

variable "username" {
    description = "IAM username"
    type        = string
}

variable "api_key" {
    description = "API key"
    type = string    
}