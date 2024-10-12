provider "aws" {
  region = var.region  # Modify as needed
  profile = var.profile
}

##### S3 Bucket for Static Website #####
resource "aws_s3_bucket" "kodek_web" {
  bucket = var.s3_bucket_name

  tags = {
    Name = var.s3_bucket_name
  }
}

resource "aws_s3_bucket_website_configuration" "kodek_web_website" {
  bucket = aws_s3_bucket.kodek_web.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "kodek_web_website" {
  bucket = aws_s3_bucket.kodek_web.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "kodek_web_policy" {
  bucket = aws_s3_bucket.kodek_web.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "s3:GetObject",
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.kodek_web.arn}/index.html",
        Principal = {"AWS":"*"},
      },
      {
        Action    = "s3:PutObject",
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.kodek_web.arn}/index.html",
        Principal = {"AWS":"${aws_iam_role.kodek_codebuild_role.arn}"},
      },
      {
        Action    = "s3:GetObject",
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.kodek_web.arn}/${var.project_name}*",
        Principal = {"AWS":"${aws_iam_role.kodek_codebuild_role.arn}"},
      }
    ],
  })
  depends_on = [ aws_s3_bucket_public_access_block.kodek_web_website ]
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.kodek_web.bucket
  key    = "index.html"
  source = "index.html"  # Path to your index.html on the AWS client host
  content_type = "text/html"
}

##### CodeCommit Repository #####
resource "aws_codecommit_repository" "kodek_codecommit_repo" {
  repository_name = var.codecommit_repo_name
  description     = "Repository for datacenter webapp"
}


##### CodePipeline #####
resource "aws_codepipeline" "kodek_pipeline" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.kodek_codepipeline_role.arn
  pipeline_type = "V2"
  execution_mode = "QUEUED"

  artifact_store {
    location = aws_s3_bucket.kodek_web.bucket
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
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}

##### CodeBuild Project #####
resource "aws_codebuild_project" "kodek_build_project" {
  name          = var.codebuild_project_name
  service_role  = aws_iam_role.kodek_codebuild_role.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "CODEPIPELINE"
    
    buildspec = <<-EOF
      version: 0.2

      phases:
        build:
          commands:
            - echo "Uploading files to S3"
            - aws s3 cp index.html s3://${aws_s3_bucket.kodek_web.bucket}/index.html

    EOF
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}
