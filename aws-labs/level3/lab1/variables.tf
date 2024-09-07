variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The AWS profile"
  type        = string
  default     = "default"
}

variable "db_admin" {  
  description = "The username for the RDS MySQL database"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS MySQL database"
  type        = string
  sensitive   = true
}

variable "ec2_instance_name" {
  description = "The Name of the existing EC2 instance"
  type        = string
}

variable "rds_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "devops_db"
}