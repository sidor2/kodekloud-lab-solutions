resource "aws_codecommit_repository" "code_repo" {
  repository_name = "${var.proj_name}-code-repo"
  default_branch = "master"
  description     = "Repository for the ${var.proj_name} Flask app"
}
