resource "aws_s3_bucket" "kodek_s3" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "app_zip" {
  bucket = aws_s3_bucket.kodek_s3.bucket
  key    = "app.zip"
  source = "./app/app.zip"
}