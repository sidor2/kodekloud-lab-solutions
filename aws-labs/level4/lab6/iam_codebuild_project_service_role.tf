resource "aws_iam_role" "codebuild_project_service_role" {
  name = "${var.proj_name}-codebuild_project_service_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_project_service_role_policy" {
  name        = "${var.proj_name}-codebuild_project_service_role_policy"
  description = "${var.proj_name} CodeBuild project service role policy"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-${var.region}-*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:codecommit:${var.region}:${var.account_id}:xfusion-code-repo"
            ],
            "Action": [
                "codecommit:GitPull"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::xfusion-artifact-bucket",
                "arn:aws:s3:::xfusion-artifact-bucket/*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation",
                "s3:GetObject"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:${var.region}:${var.account_id}:report-group/${var.proj_name}-build-project-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
  })
}

resource "aws_iam_policy_attachment" "codebuild_project_service_role_policy_attachment" {
  name       = "${var.proj_name}-codebuild_project_service_role_policy_attachment"
  roles      = [aws_iam_role.codebuild_project_service_role.name]
  policy_arn = aws_iam_policy.codebuild_project_service_role_policy.arn
}