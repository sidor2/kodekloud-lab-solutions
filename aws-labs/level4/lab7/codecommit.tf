resource "aws_codecommit_repository" "repo" {
  repository_name = "${var.proj_name}-lambda-repo"
  description     = "Repository for Lambda function source code"
  default_branch = "master"
}

