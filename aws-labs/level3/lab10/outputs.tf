output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.devops_eks.name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.devops_eks.endpoint
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.devops_eks.version
}
