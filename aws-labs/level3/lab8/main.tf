provider "aws" {
  region = "us-east-1"  # Adjust the region as needed
  profile = "kodek"
}

resource "aws_kms_key" "kodek_kms_key" {
  description             = "kodek KMS Key for encrypting sensitive data"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true

  tags = {
    Name = var.key_name
  }
}

resource "aws_kms_alias" "kodek_kms_alias" {
  name          = "alias/${var.key_name}"
  target_key_id = aws_kms_key.kodek_kms_key.id
}

output "kms_key_id" {
  value = aws_kms_key.kodek_kms_key.id
}

output "aws_kms_alias" {    
  value = aws_kms_alias.kodek_kms_alias.name
}