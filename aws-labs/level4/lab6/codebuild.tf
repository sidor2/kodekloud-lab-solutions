resource "aws_codebuild_project" "build_project" {
  name          = "${var.proj_name}-build-project"
  description   = "CodeBuild project for ${var.proj_name}"
  service_role  = aws_iam_role.codebuild_project_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"  # Update as necessary
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  source {
    type      = "CODECOMMIT"
    location  = aws_codecommit_repository.code_repo.clone_url_http
    buildspec = <<EOF
      version: 0.2

      phases:
        install:
          commands:
            - echo Installing dependencies...
        pre_build:
          commands:
            - echo Logging in to Amazon ECR...
            - aws ecr get-login-password --region "${var.region}" | docker login --username AWS --password-stdin "${aws_ecr_repository.ecr_repo.repository_url}"
        build:
          commands:
            - echo Building the Docker image...
            - docker build -t "${aws_ecr_repository.ecr_repo.repository_url}:latest" .
        post_build:
          commands:
            - echo Pushing the Docker image to ECR...
            - docker push "${aws_ecr_repository.ecr_repo.repository_url}:latest"
            - echo Creating imagedefinitions.json file...
            - printf '[{"name":"%s","imageUri":"%s"}]' "${var.proj_name}-container" "${aws_ecr_repository.ecr_repo.repository_url}:latest" > imagedefinitions.json

      artifacts:
        files:
          - '**/*'
        discard-paths: yes
        secondary-artifacts:
          imagedefinitions:
            files:
              - imagedefinitions.json
      EOF
    }

  tags = {
    Environment = "Dev"
  }
}



