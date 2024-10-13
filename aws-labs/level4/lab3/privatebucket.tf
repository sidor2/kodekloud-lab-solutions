resource "aws_s3_bucket" "kodek_private_s3" {
  
    bucket = "${var.project_name}-private-${var.s3_private_bucket_name}"
    
    tags = {
        Name = "${var.project_name}-private-${var.s3_private_bucket_name}"
    }
}

resource "aws_s3_bucket_policy" "kodek_private_s3_policy" {
    bucket = aws_s3_bucket.kodek_private_s3.bucket
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action    = ["s3:PutObject"],
                Effect    = "Allow",
                Resource  = "${aws_s3_bucket.kodek_private_s3.arn}/*",
                Principal = {"AWS":"${aws_iam_role.lambda_execution_role.arn}"}
            }
        ],
    })
}