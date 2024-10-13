resource "aws_s3_bucket" "kodek_public_s3" {
  bucket = "${var.project_name}-public-${var.s3_public_bucket_name}"

  tags = {
    Name = "${var.project_name}-public-${var.s3_public_bucket_name}"
  }
}

resource "aws_s3_bucket_public_access_block" "kodek_public_s3_pab" {
  bucket = aws_s3_bucket.kodek_public_s3.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "kodek_public_s3_policy" {
  bucket = aws_s3_bucket.kodek_public_s3.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = ["s3:GetObject","s3:PutObject"],
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.kodek_public_s3.arn}/*",
        Principal = {"AWS":"*"},
      }
    ],
  })
  depends_on = [ aws_s3_bucket_public_access_block.kodek_public_s3_pab ]
}