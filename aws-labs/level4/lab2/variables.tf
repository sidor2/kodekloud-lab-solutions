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

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for the static website"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "codecommit_repo_name" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "codepipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "codebuild_role_name" {
  description = "Name of the IAM role for CodeBuild"
  type        = string
}
