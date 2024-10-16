resource "aws_codecommit_repository" "kodek_codecommit_repo" {
  repository_name = "${var.project_name}-code-repo"
  description     = "Repository for ${var.project_name} webapp"
  default_branch = "main"

  depends_on = [ aws_iam_user_ssh_key.codecommit_ssh_key ]
}
