provider "aws" {
  region = "us-east-1"  # Specify the AWS region
  profile = "kodek"
}

resource "aws_s3_bucket" "kodek_web" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
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

output "website_url" {
  value       = "http://${aws_s3_bucket.kodek_web.bucket}.s3-website.us-east-1.amazonaws.com"
  description = "The URL of the hosted static website"
}
