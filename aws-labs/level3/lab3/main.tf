# main.tf

provider "aws" {
  region = "us-east-1"  # specify your region
  profile = "kodek"
}

resource "aws_s3_bucket" "xfusion_s3" {
  bucket = "xfusion-s3-21965"

  tags = {
    Name = "xfusion-s3-21965"
  }
}

resource "aws_iam_policy" "xfusion_s3_policy" {
  name        = "xfusion-s3-policy"
  description = "Policy for accessing xfusion-s3-21965"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::xfusion-s3-21965",
          "arn:aws:s3:::xfusion-s3-21965/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "xfusion_role" {
  name               = "xfusion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "xfusion-role"
  }
}

resource "aws_iam_role_policy_attachment" "xfusion_role_policy_attach" {
  role       = aws_iam_role.xfusion_role.name
  policy_arn = aws_iam_policy.xfusion_s3_policy.arn
}


resource "aws_iam_instance_profile" "xfusion_instance_profile" {
  name = "xfusion-instance-profile"
  role = aws_iam_role.xfusion_role.name
}

output "xfusion_instance_profile" {
  value = aws_iam_instance_profile.xfusion_instance_profile.arn
}
