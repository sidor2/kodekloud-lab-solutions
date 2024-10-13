variable "region" {
  description = "AWS region"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

# variable "account_id" {
#   description = "AWS account ID"
#   type        = string
# }

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "s3_public_bucket_name" {
  description = "Name of the S3 bucket for the static website"
  type        = string
}

variable "s3_private_bucket_name" {
  description = "Name of the S3 bucket for the static website"
  type        = string
}

