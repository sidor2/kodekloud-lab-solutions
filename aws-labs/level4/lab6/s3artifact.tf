resource "aws_s3_bucket" "artifact_bucket" {
    bucket = "${var.proj_name}-artifact-bucket"
    
    tags = {
        Name        = "${var.proj_name}-ArtifactBucket"
        Environment = "Dev"
    }
}
