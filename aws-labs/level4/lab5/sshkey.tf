# Generate SSH key pair using the tls_private_key resource
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Output the private key to use locally for SSH access
output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

# Output the public key that will be uploaded to IAM
output "ssh_public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}

# Upload the public key to the IAM user for CodeCommit access
resource "aws_iam_user_ssh_key" "codecommit_ssh_key" {
  encoding        = "SSH"
  username        = var.username
  public_key = tls_private_key.ssh_key.public_key_openssh
}