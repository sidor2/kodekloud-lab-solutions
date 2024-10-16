resource "aws_codepipeline" "kodek_pipeline" {
  name = "${var.project_name}-pipeline"
  
  role_arn = aws_iam_role.kodek_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.kodek_codecommit_repo.repository_name
        BranchName     = "main"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ElasticBeanstalk"
      version          = "1"
      input_artifacts  = ["source_output"]

      configuration = {
        ApplicationName = aws_elastic_beanstalk_application.kodek_app.name
        EnvironmentName = aws_elastic_beanstalk_environment.kodek_app_env.name
      }
    }
  }
}
