variable "application_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "service_role_arn" {
  description = "The ARN of the service role"
  type        = string
}

variable "version_label" {
  description = "The version label"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the instance profile"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default = ""
}