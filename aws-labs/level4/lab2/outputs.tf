output "s3_bucket_website_url" {
  description = "URL of the S3 static website"
  value       = aws_s3_bucket.kodek_web.bucket_domain_name
}

output "codecommit_repo_clone_url" {
  description = "URL to clone the CodeCommit repository"
  value       = aws_codecommit_repository.kodek_codecommit_repo.clone_url_http
}
