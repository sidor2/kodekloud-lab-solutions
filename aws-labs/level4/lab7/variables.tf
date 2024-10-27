variable "region" {
  description = "AWS region where resources will be deployed"
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS profile to use for authentication"
  default     = "default"
}

variable "proj_name" { 
    type = string
}
