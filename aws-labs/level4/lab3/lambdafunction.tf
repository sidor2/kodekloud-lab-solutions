# Lambda function
resource "aws_lambda_function" "devops_copy_function" {
  function_name = "${var.project_name}-copyfunction"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda-function.lambda_handler"
  runtime       = "python3.9"

  # Upload Lambda code from the local file
  filename      = "lambda-function.zip"

  environment {
    variables = {
      PRIVATE_BUCKET   = aws_s3_bucket.kodek_private_s3.bucket
      DYNAMODB_TABLE   = aws_dynamodb_table.kodek_ddb_table.name
    }
  }
}

# S3 bucket event to trigger Lambda function on file uploads
resource "aws_s3_bucket_notification" "public_bucket_notifications" {
  bucket = aws_s3_bucket.kodek_public_s3.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.devops_copy_function.arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.s3_invoke_lambda]
}

# Allow the S3 bucket to invoke the Lambda function
resource "aws_lambda_permission" "s3_invoke_lambda" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.devops_copy_function.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.kodek_public_s3.arn
}
