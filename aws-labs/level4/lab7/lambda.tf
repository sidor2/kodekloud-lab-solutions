resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.proj_name}-lambda-function"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn

  # Temporary placeholder for code, which will be replaced by the pipeline
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = "placeholder.zip"  # This will be replaced during the pipeline deploy

  environment {
    variables = {
      ENV = "test"
    }
  }
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.proj_name}-lambda-code-bucket"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "nautilus-lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  role   = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "logs:*",
        "lambda:*"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}
