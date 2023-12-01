output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.my_eks.cluster_name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.my_eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.my_eks.cluster_endpoint
}


