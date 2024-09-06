provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_iam_role" "eksClusterRole" {
  name = "eksClusterRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "eks.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eksClusterPolicyAttachment" {
  role       = aws_iam_role.eksClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "devops_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eksClusterRole.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = data.aws_subnets.selected_subnets.ids

    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.eksClusterPolicyAttachment
  ]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "selected_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availabilityZone"
    values = var.allowed_azs
  }
}