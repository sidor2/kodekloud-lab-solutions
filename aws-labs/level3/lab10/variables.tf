variable "region" {
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS profile to use"
  default     = "default"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "devops-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version to deploy"
  default     = "1.30"
}

variable "allowed_azs" {
  description = "The list of allowed availability zones for the EKS cluster"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}