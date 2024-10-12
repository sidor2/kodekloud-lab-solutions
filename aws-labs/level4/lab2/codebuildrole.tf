# IAM Role for CodeBuild
resource "aws_iam_role" "kodek_codebuild_role" {
  name = "${var.project_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "kodek_codebuild_policy" {
  name   = "CodeBuildLogsS3Policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}",
          "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "arn:aws:s3:::codepipeline-${var.region}-*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        Resource = [
          "arn:aws:codebuild:${var.region}:${var.account_id}:report-group/${var.codebuild_project_name}-*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "kodek_attach_codebuild_policy" {
  role       = aws_iam_role.kodek_codebuild_role.name
  policy_arn = aws_iam_policy.kodek_codebuild_policy.arn
}